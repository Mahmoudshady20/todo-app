import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/provider/auth_provider.dart';
import 'package:todo/provider/settings_provider.dart';
import 'package:todo/shared_prefrences/shared_prrefrences.dart';
import 'package:todo/ui/component/themedata.dart';
import 'package:todo/ui/home_screen/home_screen.dart';
import 'package:todo/ui/home_screen/list_screen/edit_task.dart';
import 'package:todo/ui/spalsh_screen/spalsh_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:todo/ui/login_screen/loginscreen.dart';
import 'package:todo/ui/register_screen/registerscreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async{
  WidgetsFlutterBinding();
  SharedPrefs.prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>(create: (context) => SettingsProvider()..init(),),
        ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider(),)
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var settingProvider = Provider.of<SettingsProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: myThemeData.lightTheme,
      darkTheme: myThemeData.darkTheme,
      themeMode: settingProvider.themeMode,
      routes: {
        LoginScreen.routeName : (_)=>LoginScreen(),
        RegisterScreen.routeName : (context) => RegisterScreen(),
        HomeScreen.routeName : (context) => HomeScreen(),
        SplashScreen.routeName : (context) => SplashScreen(),
        EditTask.routeName : (context) => EditTask(),
      },
      initialRoute: SplashScreen.routeName,
      localizationsDelegates: [
        AppLocalizations.delegate, // Add this line
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
    );
  }
}
//android   1:1056266634003:android:41702a8761ccf6067450e6
// ios       1:1056266634003:ios:480275fe92db103a7450e6

