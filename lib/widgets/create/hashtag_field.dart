import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  queryHashtagData(String query) async {
    Future<QuerySnapshot> hashtags = hashtagsRef
        .where('hashtag_name', isGreaterThanOrEqualTo: query.trim())
        .where('hashtag_name', isLessThan: query.trim() + 'z')
        .get();
    setState(() {
      searchResultsFuture = hashtags;
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
                                        backgroundColor: Colors.blue[100],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        label: Text(s,
                                            style: TextStyle(
                                                color: Colors.blue[900])),
                                        onDeleted: () {
                                          setState(() {
                                            selected.remove(s);
                                          });
                                        });
                                  }).toList()),
                            ))),
            ),
            const SizedBox(height: 20),
            ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                physics: const ScrollPhysics(),
                itemBuilder: (c, i) {
                  return ListTile(
                      title: Text(list[i],
                          style: TextStyle(color: Colors.blue[900])),
                      onTap: () {
                        setState(() {
                          if (!selected.contains(list[i]) && selected.length < 4) {
                            selected.add(list[i]);
                          }
                        });
                      });
                })
          ]),
    );
  }

  void _onChipTapped(Hashtag profile) {
    print('$profile');
  }

  void _onChanged(List<Hashtag> data) {
    print('onChanged $data');
  }

// Future<List<Hashtag>> _findSuggestions(String query) async {
//   if (query.isNotEmpty) {
//     return mockResults.where((profile) {
//       return profile.name.contains(query) || profile.email.contains(query);
//     }).toList(growable: false);
//   } else {
//     return const <Hashtag>[];
//   }
// }
}

const mockResults = <Hashtag>[
  // AppProfile('Stock Man', 'stock@man.com', 'https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1581606254-51OOsCOVw3L.jpg?crop=0.990xw:0.980xh;0.00253xw,0.00800xh&resize=768:*'),
  // AppProfile('Paul', 'paul@google.com', 'https://i.pcmag.com/imagery/articles/00DDUM2F1UuVX1ciAvfJqM3-9.1623763322.fit_lim.size_1600x900.jpg'),
  // AppProfile('Fred', 'fred@google.com',
  //     'https://static1.colliderimages.com/wordpress/wp-content/uploads/2020/10/video-games-release-date-calendar.png?q=50&fit=contain&w=750&h=375&dpr=1.5'),
  // AppProfile('Bera', 'bera@flutter.io',
  //     'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/most-popular-video-games-of-2020-1582141293.png?crop=1.00xw:1.00xh;0,0&resize=980:*'),
  // AppProfile('John', 'john@flutter.io',
  //     'https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1581605670-image.jpg?crop=0.800xw:1xh;center,top&resize=768:*'),
  // AppProfile('Thomas', 'thomas@flutter.io',
  //     'https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1581614836-51-oioaJsZL.jpg?crop=1xw:0.995xh;center,top&resize=768:*'),
  // AppProfile('Norbert', 'norbert@flutter.io',
  //     'https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1581605863-Madden-NFL-20.jpg?crop=1.00xw:0.965xh;0,0.00865xh&resize=768:*'),
  // AppProfile('Marina', 'marina@flutter.io',
  //     'https://hips.hearstapps.com/vader-prod.s3.amazonaws.com/1581605934-61CRUPJ9VLL.jpg?crop=1xw:0.995xh;center,top&resize=768:*'),
];

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
