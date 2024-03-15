import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Screens/authentication/login_screen.dart';
import 'Screens/home/home_screen.dart';
import 'Services/navigation_service.dart';
import 'Services/user_provider.dart';
import 'Util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Util/size_config.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
 MultiProvider(
    providers: [
      ChangeNotifierProvider<UserProvider>(
          create: (context) => UserProvider()),
      ChangeNotifierProvider<NavigationService>(
        create: (_) => NavigationService(),
      ),
    ],
    child: MyApp(),
  )
  );
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      title: 'Chat App',
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: AppColors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if(snapshot.hasData){
            Future.delayed(Duration(milliseconds: 500), () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            });
            return Container();
          }
          Future.delayed(Duration(milliseconds: 500), () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          });
          return Container();
        },
      ),
    );
  }
}
