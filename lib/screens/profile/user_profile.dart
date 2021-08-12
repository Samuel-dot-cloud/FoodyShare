import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_share/models/user_model.dart';
import 'package:food_share/screens/profile/edit_profile.dart';
import 'package:food_share/services/auth_service.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/viewmodel/loading_animation.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../auth/login_screen.dart';
import '../auth/sign_up_screen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key, required this.profileId}) : super(key: key);
  final String? profileId;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _isOpen = false;
  final PanelController _panelController = PanelController();
  final _imageList = [
    // 'assets/images/img-1.jpg',
    // 'assets/images/img-2.jpg',
    // 'assets/images/img-3.jpg',
    // 'assets/images/img-4.jpg',
    // 'assets/images/img-5.jpg',
    // 'assets/images/img-6.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          FractionallySizedBox(
            alignment: Alignment.topCenter,
            heightFactor: 0.7,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage( Provider.of<FirebaseOperations>(context, listen: false)
                      .getUserImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: 0.3,
            child: Container(
              color: Colors.white,
            ),
          ),

          /// Sliding panel
          SlidingUpPanel(
            controller: _panelController,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32.0),
              topRight: Radius.circular(32.0),
            ),
            minHeight: size.height * 0.35,
            maxHeight: size.height * 0.75,
            body: GestureDetector(
              onTap: () => _panelController.close(),
              child: Container(
                color: Colors.transparent,
              ),
            ),
            panelBuilder: (ScrollController controller) =>
                _panelBody(controller),
            onPanelSlide: (value) {
              if (value >= 0.2) {
                if (!_isOpen) {
                  setState(() {
                    _isOpen = true;
                  });
                }
              }
            },
            onPanelClosed: () {
              setState(() {
                _isOpen = false;
              });
            },
          ),
        ],
      ),
    );
  }

  ///Panel body
  SingleChildScrollView _panelBody(ScrollController controller) {
    double hPadding = 40.0;

    return SingleChildScrollView(
      controller: controller,
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: hPadding),
            height: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _titleSection(),
                _infoSection(),
                _actionSection(hPadding: hPadding),
              ],
            ),
          ),
          _imageList.isNotEmpty ? GridView.builder(
            primary: false,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _imageList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16.0,
            ),
            itemBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_imageList[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ) : _defaultNoRecipes(),
        ],
      ),
    );
  }

  ///Action section
  Row _actionSection({required double hPadding}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Visibility(
          visible: !_isOpen,
          child: Expanded(
            child: OutlinedButton(
              onPressed: () => _panelController.open(),
              child: const Text(
                'VIEW PROFILE',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: const BorderSide(color: kBlue),
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: !_isOpen,
          child: const SizedBox(
            width: 16.0,
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: _isOpen
                  ? (MediaQuery.of(context).size.width - (2 * hPadding)) / 1.6
                  : double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                  );
                },
                child: const Text(
                  'EDIT PROFILE',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(kBlue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: const BorderSide(color: kBlue),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Info section
  Row _infoSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoCell(title: 'Posts', value: '0'),
        Container(
          width: 1.5,
          height: 40.0,
          color: Colors.grey,
        ),
        _infoCell(title: 'Followers', value: '0'),
        Container(
          width: 1.5,
          height: 40.0,
          color: Colors.grey,
        ),
        _infoCell(title: 'Following', value: '0'),
      ],
    );
  }

  /// Info cell
  Column _infoCell({required String title, required String value}) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  ///Title section
  Column _titleSection() {
    return Column(
      children: [
        Text(
          Provider.of<FirebaseOperations>(context, listen: false)
              .getDisplayName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 30.0,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          '@' +Provider.of<FirebaseOperations>(context, listen: false)
              .getUsername,
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 22.0,
          ),
        ),
      ],
    );
  }

  Center _defaultNoRecipes(){
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width * 0.80,
            child: Lottie.asset('assets/lottie/no-post.json'),
          ),
          const SizedBox(height: 20.0,),
          const Text(
            'No Recipes Here...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25.0,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}
