import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/services/theme_service.dart';
import 'package:food_share/utils/palette.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeOptions extends StatefulWidget {
  const ThemeOptions({Key? key}) : super(key: key);

  @override
  State<ThemeOptions> createState() => _ThemeOptionsState();
}

class _ThemeOptionsState extends State<ThemeOptions> {
  bool _isSwitchedToDarkTheme = false;

  @override
  void initState() {
    super.initState();
    getSwitchValue();
  }

  getSwitchValue() async {
    _isSwitchedToDarkTheme = await getSwitchState();
    setState(() {});
  }

  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("switchState", value);
    return prefs.setBool("switchState", value);
  }

  Future<bool> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSwitchedToDarkTheme = prefs.getBool("switchState")!;

    return _isSwitchedToDarkTheme;
  }

  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    return SwitchListTile(
      title: const Text('Dark Mode'),
      activeColor: kBlue,
      value: _isSwitchedToDarkTheme,
      onChanged: (bool value) {
        setState(() {
          _isSwitchedToDarkTheme = value;
          saveSwitchState(value);
        });
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
        Fluttertoast.showToast(
            msg: 'Restart app for changes to take effect.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: kBlue,
            textColor: Colors.white,
            fontSize: 16.0);
      },
      secondary: const Icon(Icons.dark_mode_outlined),
    );

  }
}
