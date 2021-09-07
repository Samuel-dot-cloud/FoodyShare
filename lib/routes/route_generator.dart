import 'package:flutter/material.dart';
import 'package:food_share/routes/alt_profile_arguments.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/recipe_details_arguments.dart';
import 'package:food_share/screens/auth/forgot_password.dart';
import 'package:food_share/screens/auth/login_screen.dart';
import 'package:food_share/screens/auth/sign_up_screen.dart';
import 'package:food_share/screens/profile/alt_profile.dart';
import 'package:food_share/screens/recipe_details.dart';
import 'package:food_share/viewmodel/bottom_nav.dart';

class RouteGenerator{
  static Route<dynamic> generateRoute(BuildContext context, RouteSettings settings){
    final argument1 = ModalRoute.of(context)!.settings.arguments as AltProfileArguments;
    final argument2 = ModalRoute.of(context)!.settings.arguments as RecipeDetailsArguments;
    switch(settings.name){
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
      case AppRoutes.bottomNav:
        return MaterialPageRoute(builder: (_) => const BottomNav());
      case AppRoutes.altProfile:
        return MaterialPageRoute(builder: (_) => AltProfile(arguments: argument1));
      case AppRoutes.recipeDetails:
        return MaterialPageRoute(builder: (_) => RecipeDetails(arguments: argument2));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
              'ERROR!!',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(
          child: Text('Seems you have navigated to a wrong route!!'),
        ),
      );
    });
  }


}

