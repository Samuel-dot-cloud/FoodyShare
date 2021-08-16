import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PreparationSection extends StatelessWidget {
  final DocumentSnapshot preparationDoc;

  const PreparationSection({Key? key, required this.preparationDoc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List preparationList =
    preparationDoc['preparation'].map((item) => item as Map)?.toList();
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              int preparationNo = index + 1;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: RichText(
                  text: TextSpan(
                    text: '$preparationNo. ',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                    children: [
                      TextSpan(
                        text: preparationList[index].values.toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: Colors.black.withOpacity(0.3),
              );
            },
            itemCount: preparationList.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
          ),
        ],
      ),
    );
  }
}
