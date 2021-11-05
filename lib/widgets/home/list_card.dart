import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_share/utils/number_formatter.dart';

class BookmarkListCard extends StatelessWidget {
  const BookmarkListCard({
    Key? key,
    required this.favoriteDoc,
  }) : super(key: key);

  final DocumentSnapshot favoriteDoc;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 150.0,
      width: size.width * 70,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildListInfoPadding(
              favoriteDoc['name'], favoriteDoc['recipe_count'].toString()),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildListImageSizedBox(size,
                    'https://www.cnet.com/a/img/_RNA_r7S_SWIJgHKcoIQpKVXf48=/756x425/2018/02/27/750ca249-56be-43e6-84f7-18dd17be1199/what-remains-of-edith-finch.png'),
                buildListImageSizedBox(size,
                    'https://www.cnet.com/a/img/vu2_7FD5zh5bZghAU19UZ_6-x_A=/756x425/2015/12/04/5487e9a1-ddb8-4a4b-bca7-6a900bad964f/foto1.jpg'),
                buildListImageSizedBox(size,
                    'https://www.cnet.com/a/img/nEDWvOvmm159B9RacVOKiNEEI98=/756x425/2016/09/26/81cd73df-9d87-4be7-8abe-6ec9dbc6c550/horizon-zero-dawn.jpg'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding buildListInfoPadding(String listName, String recipeCount) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 10.0),
      child: Column(
        children: [
          Text(
            listName,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Text(
            NumberFormatter.formatter(recipeCount) + ' recipes',
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
        ],
      ),
    );
  }

  ClipRRect buildListImageSizedBox(Size size, String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: SizedBox(
        height: 80.0,
        width: size.width * 0.3,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          alignment: Alignment.centerLeft,
          imageUrl: imageUrl,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(
            value: downloadProgress.progress,
            backgroundColor: Colors.cyanAccent,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }
}
