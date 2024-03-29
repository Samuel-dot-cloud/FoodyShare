import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_share/helpers/activity_feed_helper.dart';
import 'package:food_share/helpers/bottom_nav_helper.dart';
import 'package:food_share/helpers/list_recipes_helper.dart';
import 'package:food_share/helpers/recipe_detail_helper.dart';
import 'package:food_share/routes/route_generator.dart';
import 'package:food_share/screens/auth/startup_view.dart';
import 'package:food_share/screens/onboard/onboarding_screen.dart';
import 'package:food_share/services/analytics_service.dart';
import 'package:food_share/services/auth_service.dart';
import 'package:food_share/services/connectivity_provider.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/helpers/profile_helper.dart';
import 'package:food_share/services/revenuecat_provider.dart';
import 'package:food_share/services/theme_service.dart';
import 'package:food_share/utils/constants.dart';
import 'package:food_share/utils/profile_util.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isViewed;
bool? darkModeOn;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance
      .activate(webRecaptchaSiteKey: 'recaptcha-v3-site-key');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isViewed = prefs.getInt('onboard');
  darkModeOn = prefs.getBool("switchState") ?? false;
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProfileHelper(),
        ),
        ChangeNotifierProvider(
          create: (context) => ListRecipesHelper(),
        ),
        ChangeNotifierProvider(
          create: (context) => RecipeDetailHelper(),
        ),
        ChangeNotifierProvider(
          create: (context) => ActivityFeedHelper(),
        ),
        ChangeNotifierProvider(
          create: (context) => FirebaseOperations(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileUtils(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNavHelper(),
        ),
        ChangeNotifierProvider(
          create: (context) => ConnectivityProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AnalyticsService(),
        ),
        ChangeNotifierProvider(
          create: (context) => RevenueCatProvider(),
        ),
      ],
      child: const FoodyShareApp(),
    ),
  );
}

class FoodyShareApp extends StatelessWidget {
  const FoodyShareApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      themeMode: changeTheme(),
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      home: getInitialPage(),
      navigatorObservers: [
        Provider.of<AnalyticsService>(context, listen: false)
            .getAnalyticsObserver()
      ],
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }

  Widget getInitialPage() {
    return isViewed != 0 ? const OnboardingScreen() : const Home();
  }

  ThemeMode changeTheme() {
    return darkModeOn == true ? ThemeMode.dark : ThemeMode.light;
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
