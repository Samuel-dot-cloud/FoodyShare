import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:google_fonts/google_fonts.dart';

class HashtagField extends StatefulWidget {
  const HashtagField({Key? key, required this.onUpdate}) : super(key: key);

  final ValueChanged<List<String>> onUpdate;

  @override
  State<HashtagField> createState() => _HashtagFieldState();
}

class _HashtagFieldState extends State<HashtagField> {
  final hashtagsRef = FirebaseFirestore.instance.collection('hashtags');
  QuerySnapshot? snapshotData;
  bool isExecuted = false;

  List<String> selected = [];
  TextEditingController? hashtagController;

  @override
  void initState() {
    super.initState();
    hashtagController = TextEditingController();
  }

  void _updateField() {
    widget.onUpdate(selected);
  }

  void _removeField() {
    widget.onUpdate(selected);
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
      child: Column(children: [
        Text(
          'Add Hashtags',
          style: kBodyText.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
              controller: hashtagController,
              onChanged: queryHashtagData,
              decoration: InputDecoration(
                hintText: 'e.g #fingerfood',
                  border: const OutlineInputBorder(
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  prefixIcon: selected.isEmpty
                      ? null
                      : Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: selected.map((s) {
                                return StreamBuilder<DocumentSnapshot>(
                                  stream: hashtagsRef
                                      .doc(s)
                                      .snapshots()
                                      .asBroadcastStream(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      _updateField();
                                      return Chip(
                                          backgroundColor: kBlue,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                          ),
                                          label: Text(
                                            snapshot.data!['hashtag_name'],
                                          ),
                                          onDeleted: () {
                                            setState(() {
                                              selected.remove(s);
                                            });
                                            _removeField();
                                          });
                                    }
                                  },
                                );
                              }).toList()),
                        ))),
        ),
        const SizedBox(height: 20),
        SizedBox(
          child: isExecuted
              ? searchedData()
              : const SizedBox(
                  width: 0.0,
                  height: 0.0,
                ),
        ),
      ]),
    );
  }

  Widget searchedData() {
    return hashtagController!.text.isNotEmpty
        ? ListView.builder(
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
                              snapshotData?.docs[index]['hashtag_id']) &&
                          selected.length < 4) {
                        selected.add(snapshotData?.docs[index]['hashtag_id']);
                      }
                    });
                  });
            })
        : const SizedBox(
            height: 0.0,
            width: 0.0,
          );
  }
}
