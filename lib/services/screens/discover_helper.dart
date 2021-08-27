// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:food_share/viewmodel/loading_animation.dart';
// import 'package:provider/provider.dart';
//
// import '../auth_service.dart';
//
// class DiscoverHelper with ChangeNotifier {
//   Widget feedBody(BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           const SizedBox(
//             height: 20,
//           ),
//
//           SizedBox(
//             child: StreamBuilder<QuerySnapshot>(
//               stream:
//                   FirebaseFirestore.instance.collection('recipes').snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return loadingAnimation('Cooking up recipes...');
//                 } else {
//                   return loadRecipeCard(context, snapshot);
//                 }
//               },
//             ),
//             height: MediaQuery.of(context).size.height * 0.9,
//             width: MediaQuery.of(context).size.width,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget loadRecipeCard(
//       BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//     return ListView(
//         children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
//       return GestureDetector(
//         onTap: () {},
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Align(
//                   alignment: Alignment.topCenter,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(24.0),
//                     child: Hero(
//                       tag: documentSnapshot['mediaUrl'],
//                       child: Image(
//                         height: 320.0,
//                         width: 320.0,
//                         fit: BoxFit.cover,
//                         image: NetworkImage(documentSnapshot['mediaUrl']),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 20.0,
//                   right: 40.0,
//                   child: InkWell(
//                     onTap: () {},
//                     child: Provider.of<AuthService>(context, listen: false)
//                                 .getuserUID ==
//                             documentSnapshot['authorId']
//                         ? IconButton(
//                             onPressed: () {},
//                             icon: const Icon(
//                               Icons.more_vert,
//                               color: Colors.white,
//                               size: 28.0,
//                             ),
//                           )
//                         : IconButton(
//                             onPressed: () {},
//                             icon: const FaIcon(
//                               FontAwesomeIcons.bookmark,
//                               color: Colors.white,
//                               size: 28.0,
//                             ),
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(
//               height: 20.0,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 24.0,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Flexible(
//                     flex: 2,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           documentSnapshot['name'],
//                           style: Theme.of(context).textTheme.subtitle1,
//                         ),
//                         const SizedBox(
//                           height: 8.0,
//                         ),
//                         Text(
//                           documentSnapshot['name'],
//                           style: Theme.of(context).textTheme.caption,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Flexible(
//                     flex: 2,
//                     child: Row(
//                       children: [
//                         const SizedBox(
//                           width: 20.0,
//                         ),
//                         const Icon(
//                           Icons.timer,
//                         ),
//                         const SizedBox(
//                           width: 4,
//                         ),
//                         Text(
//                           documentSnapshot['cookingTime'],
//                         ),
//                         const Spacer(),
//                         InkWell(
//                           onTap: () {},
//                           child: const FaIcon(
//                             FontAwesomeIcons.gratipay,
//                             color: Colors.red,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       );
//     }).toList());
//   }
// }
