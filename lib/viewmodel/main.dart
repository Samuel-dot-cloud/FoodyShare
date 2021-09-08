import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_share/Viewmodel/bottom_nav.dart';
import 'package:food_share/helpers/bottom_nav_helper.dart';
import 'package:food_share/routes/alt_profile_arguments.dart';
import 'package:food_share/routes/app_routes.dart';
import 'package:food_share/routes/recipe_details_arguments.dart';
import 'package:food_share/routes/route_generator.dart';
import 'package:food_share/screens/auth/forgot_password.dart';
import 'package:food_share/screens/auth/startup_view.dart';
import 'package:food_share/screens/auth/login_screen.dart';
import 'package:food_share/screens/auth/sign_up_screen.dart';
import 'package:food_share/screens/onboard/onboarding_screen.dart';
import 'package:food_share/screens/profile/alt_profile.dart';
import 'package:food_share/screens/home/recipe_details.dart';
import 'package:food_share/services/auth_service.dart';
import 'package:food_share/services/connectivity_provider.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/helpers/profile_helper.dart';
import 'package:food_share/services/sign_up_service.dart';
import 'package:food_share/utils/sign_up_util.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isViewed;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance
      .activate(webRecaptchaSiteKey: 'recaptcha-v3-site-key');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt('onboard');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProfileHelper(),
        ),
        ChangeNotifierProvider(
          create: (context) => FirebaseOperations(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => SignUpUtils(),
        ),
        ChangeNotifierProvider(
          create: (context) => SignUpService(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNavHelper(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
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
            GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
      ),
      home: getInitialPage(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }

  Widget getInitialPage() {
    return isViewed != 0 ? const OnboardingScreen() : const Home();
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

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
