import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/utils/palette.dart';
import 'package:google_fonts/google_fonts.dart';

class HashtagField extends StatefulWidget {
  const HashtagField({Key? key, required this.onUpdate}) : super(key: key);

  final ValueChanged<List<String>> onUpdate;

  @override
  State<HashtagField> createState() => _HashtagFieldState();
}

class _HashtagFieldState extends State<HashtagField> {
  final _hashtagsRef = FirebaseFirestore.instance.collection('hashtags');
  QuerySnapshot? _snapshotData;
  bool _isExecuted = false;

  final List<String> _selected = [];
  TextEditingController? _hashtagController;

  @override
  void initState() {
    super.initState();
    _hashtagController = TextEditingController();
  }

  @override
  void dispose() {
    _hashtagController?.dispose();
    super.dispose();
  }

  void _updateField() {
    widget.onUpdate(_selected);
  }

  void _removeField() {
    widget.onUpdate(_selected);
  }

  queryHashtagData(String query) {
    return _hashtagsRef
        .where('hashtag_name', isGreaterThanOrEqualTo: query.trim())
        .where('hashtag_name', isLessThan: query.trim() + 'z')
        .get()
        .then((value) {
      _snapshotData = value;
    }).whenComplete(() {
      setState(() {
        _isExecuted = true;
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
            controller: _hashtagController,
            onChanged: queryHashtagData,
            decoration: const InputDecoration(
              hintText: 'e.g #fingerfood',
              prefixIcon: Icon(
                Icons.grid_3x3_outlined,
              ),
              border: UnderlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 15.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
              decoration: InputDecoration(
                  hintText: 'Add up to 5 hashtags...',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  prefixIcon: _selected.isEmpty
                      ? null
                      : Padding(
                          padding:
                              const EdgeInsets.only(left: 10, right: 10),
                          child: Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: _selected.map((s) {
                                return StreamBuilder<DocumentSnapshot>(
                                  stream: _hashtagsRef
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
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          onDeleted: () {
                                            setState(() {
                                              _selected.remove(s);
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
          child: _isExecuted
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
    return _hashtagController!.text.trim().isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: _snapshotData?.docs.length,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: Text(_snapshotData?.docs[index]['hashtag_name'],
                      style: TextStyle(color: Colors.blue[900])),
                  onTap: () {
                    setState(() {
                      if (!_selected.contains(
                              _snapshotData?.docs[index]['hashtag_id']) &&
                          _selected.length < 5) {
                        _selected.add(_snapshotData?.docs[index]['hashtag_id']);
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
