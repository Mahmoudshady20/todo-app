import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/auth_provider.dart';
import 'package:todo/ui/home_screen/home_screen.dart';
import 'package:todo/ui/spalsh_screen/spalsh_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:todo/ui/login_screen/loginscreen.dart';
import 'package:todo/ui/register_screen/registerscreen.dart';

void main() async{
  WidgetsFlutterBinding();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => AuthProvider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFDFECDB),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        )
      ),
      routes: {
        LoginScreen.routeName : (_)=>LoginScreen(),
        RegisterScreen.routeName : (context) => RegisterScreen(),
        HomeScreen.routeName : (context) => HomeScreen(),
        SplashScreen.routeName : (context) => SplashScreen(),
      },
      initialRoute: SplashScreen.routeName,
    );
  }
}
//android   1:1056266634003:android:41702a8761ccf6067450e6
// ios       1:1056266634003:ios:480275fe92db103a7450e6

