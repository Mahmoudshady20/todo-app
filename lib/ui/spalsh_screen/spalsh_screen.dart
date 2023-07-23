import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/mydatabase.dart';
import 'package:todo/provider/auth_provider.dart';
import 'package:todo/ui/home_screen/home_screen.dart';
import 'package:todo/ui/login_screen/loginscreen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2),(){
      login();
    });
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/splash.png'), fit: BoxFit.fill)),
    );
  }

  void login() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (FirebaseAuth.instance.currentUser != null) {
      var user = await authProvider.getUserFromDataBase();
      if (user != null) {
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        return;
      }
    }
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }
}
