import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/auth_provider.dart';
import 'package:todo/ui/login_screen/loginscreen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'homescreen';

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            provider.signout();
            Navigator.pushReplacementNamed(context, LoginScreen.routeName);
          }, icon: Icon(Icons.logout))
        ],
      ),
    );
  }
}
