import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/config/size_config.dart';

class RecipeCollectionCard extends StatelessWidget {
  const RecipeCollectionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double size = SizeConfig.defaultSize;
    return AspectRatio(
      aspectRatio: 1.65,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size * 1.0,
          vertical: size * 1.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(size * 1.8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(size * 2.0),
                  child: Column(
                    children: [
                      const Spacer(),
                      Text(
                        'Course',
                        style: TextStyle(
                          fontSize: size * 2.2,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: size * 0.5,
                      ),
                      const Text(
                        'Recipes ordered by course',
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      buildInfoRow(size,
                          data: Icons.person, text: '30 authors'),
                      SizedBox(
                        height: size * 0.5,
                      ),
                      buildInfoRow(size,
                          data: FontAwesomeIcons.utensils, text: '70 recipes'),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: size * 0.5,
              ),
              AspectRatio(
                aspectRatio: 0.71,
                child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGUluUzhynemnSpHeY3OCRf4UVsdhfB83D3g&usqp=CAU',
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildInfoRow(double size,
      {required IconData data, required String text}) {
    return Row(
      children: [
        Icon(
          data,
          color: Colors.white,
          size: 22.0,
        ),
        SizedBox(
          width: size,
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
