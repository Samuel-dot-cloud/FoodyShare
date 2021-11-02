import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PreparationSection extends StatelessWidget {
  final List preparations;

  const PreparationSection({Key? key, required this.preparations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List? preparationList = preparations.map((item) => item as Map).toList();
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              int preparationNo = index + 1;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: RichText(
                  overflow: TextOverflow.fade,
                  text: TextSpan(
                    style: GoogleFonts.josefinSans(
                      textStyle: const TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                    children: [
                      TextSpan(
                        text: '$preparationNo. ',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: preparationList[index].values.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.onPrimary,
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
