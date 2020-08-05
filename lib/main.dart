import 'package:flutter/material.dart';
import 'package:app0/Screens/Loading/loading_screen.dart';
import 'package:app0/Screens/Welcome/welcome_screen.dart';
import 'package:app0/Screens/Home/home_welcome.dart';
import 'package:app0/Screens/User/parent_user.dart';
import 'package:app0/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

/*class MyApp extends StatelessWidget {
  // This widget is the root of your application.
*/
class MyApp extends StatefulWidget {
  // This widget is the root of your application
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _status, load = true, accept;
  Future<void> _loggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _status = prefs.getBool('loggedIn');
      if (_status == null) {
        _status = false;
      }
      accept = prefs.getBool('accepted');
      if (accept == null) {
        accept = false;
      }

      load = false;
    });
    print(_status);
    print(accept);
  }

  @override
  void initState() {
    super.initState();
    _loggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LAZARUS',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: load == true
          ? LoadingScreen()
          : (_status
              ? (accept ? ParentUser() : HomeWelcome())
              : WelcomeScreen()),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => HomeWelcome(),
        '/user': (context) => ParentUser(),
        '/app0': (context) => MyApp()
      },
    );
  }
}
