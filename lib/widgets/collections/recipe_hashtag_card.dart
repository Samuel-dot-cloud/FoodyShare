import 'package:flutter/material.dart';
import 'package:food_share/config/size_config.dart';
import 'package:food_share/widgets/collections/icon_font.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipeHashtagCard extends StatelessWidget {
  const RecipeHashtagCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double size = SizeConfig.defaultSize;
    return Container(
      margin: EdgeInsets.all(size * 2.0),
      height: 150.0,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: 'https://www.getdroidtips.com/wp-content/uploads/2019/12/Call-of-Duty-Wallpapers-Download-in-High-Resolution.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              height: 120.0,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: Padding(
              padding: EdgeInsets.all(size * 1.0),
              child: Row(
                children: [
                  ClipOval(
                    child: Container(
                      color: Colors.brown,
                      padding: EdgeInsets.all(size * 1.0),
                      child: IconFont(
                        color: Colors.white,
                        size: size * 3.0,
                        iconName: 'a',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size * 1.0,
                  ),
                  Text(
                    'Test',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 2.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
