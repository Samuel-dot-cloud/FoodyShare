import 'package:flutter/material.dart';
import 'package:food_share/routes/alt_profile_arguments.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/recipe_details_arguments.dart';
import 'package:food_share/screens/auth/forgot_password.dart';
import 'package:food_share/screens/auth/login_screen.dart';
import 'package:food_share/screens/auth/sign_up_screen.dart';
import 'package:food_share/screens/collection/recipe_collections_screen.dart';
import 'package:food_share/screens/collection/recipe_hashtag_screen.dart';
import 'package:food_share/screens/profile/alt_profile.dart';
import 'package:food_share/screens/home/recipe_details.dart';
import 'package:food_share/screens/profile/settings/edit_profile.dart';
import 'package:food_share/screens/profile/settings/profile_settings.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/viewmodel/bottom_nav.dart';
import 'package:lottie/lottie.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return buildRoute(const LoginScreen(), settings: settings);
      case AppRoutes.register:
        return buildRoute(const SignUpScreen(), settings: settings);
      case AppRoutes.forgotPassword:
        return buildRoute(const ForgotPassword(), settings: settings);
      case AppRoutes.bottomNav:
        return buildRoute(const BottomNav(), settings: settings);
      case AppRoutes.collections:
        return buildRoute(const RecipeCollectionsScreen(), settings: settings);
      case AppRoutes.hashtags:
        return buildRoute(const RecipeHashtagScreen(), settings: settings);
      case AppRoutes.settings:
        return buildRoute(const ProfileSettings(), settings: settings);
      case AppRoutes.editProfile:
        return buildRoute(const EditProfilePage(), settings: settings);
      case AppRoutes.altProfile:
        final argument1 = settings.arguments as AltProfileArguments;
        return buildRoute(AltProfile(arguments: argument1), settings: settings);
      case AppRoutes.recipeDetails:
        final argument2 = settings.arguments as RecipeDetailsArguments;
        return buildRoute(RecipeDetails(arguments: argument2),
            settings: settings);
      default:
        return _errorRoute();
    }
  }

  static MaterialPageRoute buildRoute(Widget child,
      {required RouteSettings settings}) {
    return MaterialPageRoute(
        settings: settings, builder: (BuildContext context) => child);
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: kBlue,
          title: const Text(
            'ERROR!!',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 450.0,
                  width: 450.0,
                  child: Lottie.asset('assets/lottie/error.json'),
                ),
                const Text(
                  'Seems the route you\'ve navigated to doesn\'t exist!!',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
