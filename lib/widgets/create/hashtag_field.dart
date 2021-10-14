import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:provider/provider.dart';

import 'hashtag_result.dart';

class HashtagField extends StatefulWidget {
  const HashtagField({Key? key}) : super(key: key);

  @override
  State<HashtagField> createState() => _HashtagFieldState();
}

class _HashtagFieldState extends State<HashtagField> {
  final hashtagsRef = FirebaseFirestore.instance.collection('hashtags');
  QuerySnapshot? snapshotData;
  bool isExecuted = false;

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

  queryHashtagData(String query) {
    return hashtagsRef
        .where('hashtag_name', isGreaterThanOrEqualTo: query.trim())
        .where('hashtag_name', isLessThan: query.trim() + 'z')
        .get()
        .then((value) {
      snapshotData = value;
    }).whenComplete(() {
      setState(() {
        isExecuted = true;
      });
    });
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
                  onChanged: queryHashtagData,
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
              child: isExecuted
                  ? searchedData()
                  : const Text(
                      'Nothing to show here'
                    ),
            ),
          ]),
    );
  }

  Widget searchedData() {
    return hashtagController!.text.isNotEmpty ? ListView.builder(
        shrinkWrap: true,
        itemCount: snapshotData?.docs.length,
        physics: const ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              title: Text(snapshotData?.docs[index]['hashtag_name'],
                  style: TextStyle(color: Colors.blue[900])),
              onTap: () {
                setState(() {
                  if (!selected.contains(
                          snapshotData?.docs[index]['hashtag_name']) &&
                      selected.length < 4) {
                    selected.add(snapshotData?.docs[index]['hashtag_name']);
                  }
                });
              });
        }) : const SizedBox(
      height: 0.0,
      width: 0.0,
    );
  }
}

// Provider.of<FirebaseOperations>(context, listen: false).queryHashtagData(data).then((value) {
// snapshotData = value;
// });
