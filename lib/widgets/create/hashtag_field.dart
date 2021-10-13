import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/utils/pallete.dart';

import 'hashtag_result.dart';

class HashtagField extends StatefulWidget {
  const HashtagField({Key? key}) : super(key: key);

  @override
  State<HashtagField> createState() => _HashtagFieldState();
}

class _HashtagFieldState extends State<HashtagField> {
  final hashtagsRef = FirebaseFirestore.instance.collection('hashtags');
  Future<QuerySnapshot>? searchResultsFuture;

  List<String> list = [
        '#java',
        '#javaScript',
        '#flutter',
        '#kotlin',
        '#swift',
        '#objective-C'
      ],
      selected = [];
  TextEditingController? hashtagController;

  @override
  void initState() {
    super.initState();
    hashtagController = TextEditingController();
  }

  Stream getHashtagCollectionStream(String query){
    return hashtagsRef
        .where('hashtag_name', isGreaterThanOrEqualTo: query.trim())
        .where('hashtag_name', isLessThan: query.trim() + 'z')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
//         mainAxisSize:MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: hashtagController,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      prefixIcon: selected.isEmpty
                          ? null
                          : Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Wrap(
                                  spacing: 5,
                                  runSpacing: 5,
                                  children: selected.map((s) {
                                    return Chip(
                                        backgroundColor: kBlue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        label: Text(s,
                                            style: const TextStyle(
                                                color: Colors.white)),
                                        onDeleted: () {
                                          setState(() {
                                            selected.remove(s);
                                          });
                                        });
                                  }).toList()),
                            ))),
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              child: StreamBuilder<QuerySnapshot>(
                stream: hashtagsRef.snapshots().asBroadcastStream(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) { 
                if(snapshot.hasError){
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting){
                  return const CircularProgressIndicator(
                    backgroundColor: Colors.cyanAccent,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                  );
                }
                if(snapshot.hasData){
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      physics: const ScrollPhysics(),
                      itemBuilder: (c, i) {
                        return ListTile(
                            title: Text(snapshot.data[i]['hashtag_name'],
                                style: TextStyle(color: Colors.blue[900])),
                            onTap: () {
                              setState(() {
                                if (!selected.contains(snapshot.data[i]['hashtag_name']) && selected.length < 4) {
                                  selected.add(snapshot.data[i]['hashtag_name']);
                                }
                              });
                            });
                      });
                }
                return const Text('Error');
              },
              ),
            ),
            // ListView.builder(
            //     shrinkWrap: true,
            //     itemCount: list.length,
            //     physics: const ScrollPhysics(),
            //     itemBuilder: (c, i) {
            //       return ListTile(
            //           title: Text(list[i],
            //               style: TextStyle(color: Colors.blue[900])),
            //           onTap: () {
            //             setState(() {
            //               if (!selected.contains(list[i]) && selected.length < 4) {
            //                 selected.add(list[i]);
            //               }
            //             });
            //           });
            //     })
          ]),
    );
  }


}

class Hashtag {
  final String name;
  final String id;
  final String collectionId;

  const Hashtag(
      {required this.name, required this.id, required this.collectionId});

  factory Hashtag.fromDocument(DocumentSnapshot doc) {
    return Hashtag(
      id: doc['hashtag_id'],
      collectionId: doc['collection_id'],
      name: doc['hashtag_name'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Hashtag &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'Profile{$name}';
  }
}
