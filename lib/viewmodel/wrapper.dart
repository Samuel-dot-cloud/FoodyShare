import 'package:flutter/material.dart';
import 'package:food_share/Viewmodel/bottom_nav.dart';
import 'package:food_share/models/user_model.dart';
import 'package:food_share/screens/auth/authenticate.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    //Return either nav or authenticate widget
    return const Authenticate();
  }
}

