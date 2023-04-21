import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaza_app/providers/areaName.dart';
import 'package:kaza_app/providers/categories.dart';
import 'package:kaza_app/providers/landmarkName.dart';
import 'package:kaza_app/providers/likeModelProvider.dart';
import 'package:kaza_app/providers/location.dart';
import 'package:kaza_app/providers/menu.dart';
import 'package:kaza_app/providers/profileProvider.dart';
import 'package:kaza_app/providers/roadName.dart';
import 'package:kaza_app/providers/vendors.dart';
import 'package:kaza_app/screens/categoryScreen.dart';
import 'package:kaza_app/screens/forgotpage.dart';
import 'package:kaza_app/screens/homeScreen.dart';
import 'package:kaza_app/screens/likesPage.dart';
import 'package:kaza_app/screens/locationScreen.dart';
import 'package:kaza_app/screens/vendorScreen.dart';
import 'package:kaza_app/screens/searchScreen.dart';
import 'package:kaza_app/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:provider/provider.dart';
import './providers/filters.dart';
import 'providers/googleMaps.dart';
import 'providers/Signup/Signup_provider.dart';
import 'providers/auth/auth_provider.dart';
import 'providers/signin/signin_provider.dart';
import 'repository/auth_repository.dart';
import 'screens/profilescreen.dart';
import 'screens/signInPage.dart';
import 'screens/signupPage.dart';
import 'screens/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => Filters()),
    ChangeNotifierProvider(create: (context) => Categories()),
    ChangeNotifierProvider(create: (context) => Vendors()),
    ChangeNotifierProvider(create: (context) => Menu()),
    ChangeNotifierProvider(create: (context) => LocationDataProvider()),
    ChangeNotifierProvider(create: (context) => RoadNames()),
    ChangeNotifierProvider(create: (context) => AreaNames()),
    ChangeNotifierProvider(create: (context) => LandmarkNames()),
    ChangeNotifierProvider(create: (context) => MapUtils()),
    ChangeNotifierProvider(create: (context) => ProfileProvider()),
    ChangeNotifierProvider(create: (context) => LikesModel()),
    Provider<AuthRepository>(
      create: (context) => AuthRepository(
          firebaseFirestore: FirebaseFirestore.instance,
          firebaseAuth: fbAuth.FirebaseAuth.instance),
    ),
    StreamProvider<fbAuth.User?>(
      create: (context) => context.read<AuthRepository>().user,
      initialData: null,
    ),
    ChangeNotifierProxyProvider<fbAuth.User?, AuthProvider>(
        create: (context) =>
            AuthProvider(authRepository: context.read<AuthRepository>()),
        update: (BuildContext context, fbAuth.User? userStream,
                AuthProvider? authProivder) =>
            authProivder!..update(userStream)),
    ChangeNotifierProvider<SigninProvider>(
      create: (context) => SigninProvider(
        authRepository: context.read<AuthRepository>(),
      ),
    ),
    ChangeNotifierProvider<SignupProvider>(
      create: (context) => SignupProvider(
        authRepository: context.read<AuthRepository>(),
      ),
    ),
  ], child: KazaApp()));
}

// The main home screen
class KazaApp extends StatelessWidget {
  const KazaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Kaza - Street Food",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Colors.orange[500],
        secondaryHeaderColor: Colors.black,
        highlightColor: Colors.white,
      ),
      // If the user is authenticated then return the home screen or the authentication screen.
      home: SplashScreen(),
      // Are we authenticated? : Yes
      // If not make a future builder.
      // Setting the routes.
      routes: {
        VendorScreenMain.routeName: (context) => VendorScreenMain(
            ModalRoute.of(context)!.settings.arguments as String),
        HomeScreen.routeName: (context) => HomeScreen(),
        CategoryScreen.routeName: ((context) => CategoryScreen(
            ModalRoute.of(context)!.settings.arguments as String)),
        SearchScreen.routeName: (context) => SearchScreen(),
        Wrapper.routeName: (context) => const Wrapper(),
        SignupPage.routeName: (context) => const SignupPage(),
        SigninPage.routeName: (context) => const SigninPage(),
        ForgotPage.routeName: (context) => const ForgotPage(),
        ProfileScreen.routeName: (context) => ProfileScreen(),
        LikesPage.routeName: (context) => LikesPage(),
        LocationScreen.routeName: (context) => LocationScreen(),
      },
    );
  }
}
