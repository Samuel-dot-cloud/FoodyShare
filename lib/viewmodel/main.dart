import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_share/Viewmodel/bottom_nav.dart';
import 'package:food_share/helpers/bottom_nav_helper.dart';
import 'package:food_share/screens/auth/forgot_password.dart';
import 'package:food_share/screens/auth/startup_view.dart';
import 'package:food_share/screens/auth/login_screen.dart';
import 'package:food_share/screens/auth/sign_up_screen.dart';
import 'package:food_share/services/auth_service.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/services/recipe_notifier.dart';
import 'package:food_share/services/screens/sign_up_service.dart';
import 'package:food_share/utils/sign_up_util.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
      webRecaptchaSiteKey: 'recaptcha-v3-site-key');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RecipeNotifier(),
        ),
        ChangeNotifierProvider(create: (context) => FirebaseOperations(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(create: (context) => SignUpUtils(),
        ),
        ChangeNotifierProvider(create: (context) => SignUpService(),
        ),
        ChangeNotifierProvider(create: (context) => BottomNavHelper(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodyShare',
      theme: ThemeData(
        textTheme:
        GoogleFonts.josefinSansTextTheme(Theme
            .of(context)
            .textTheme),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        'home': (context) => const BottomNav(),
        'login': (context) => const LoginScreen(),
        'ForgotPassword': (context) => const ForgotPassword(),
        'SignUp': (context) => const SignUpScreen(),
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return const StartupView();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.cyanAccent,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
          ),
        );
      },
    );
  }
}
