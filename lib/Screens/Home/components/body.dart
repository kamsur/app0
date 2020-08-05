import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:app0/Screens/Home/components/background.dart';
import 'package:app0/Screens/Loading/loading_screen.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:app0/components/rounded_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app0/DB/database_provider.dart';

/*class Body extends StatelessWidget {
  final Map data;
  const Body({
    Key key,
    @required this.data,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    print(data);
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "ACCESS TOKEN PAYLOAD",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            Text(
              "$data",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            /*SvgPicture.asset(
              "assets/icons/stethescope.svg",
              height: size.height * 0.45,
            ),*/
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "NEXT",
              press: () async {
                await _setAccepted(true);
                Navigator.pushReplacementNamed(context, '/app0');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setAccepted(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('accepted', status);
    print("Accepted set");
  }
}*/

//This is for Stateful Widget
class Body extends StatefulWidget {
  final Map data;
  const Body({
    Key key,
    @required this.data,
  }) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool loading = true;
  bool entered;
  var data;
  String user;
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Future<void> _display() async {
    final prefs = await SharedPreferences.getInstance();
    user = prefs.getString('nullOid');
    if (user == null) {
      data = await DatabaseProvider.db.getNullDisplayName();
    } else {
      data = await DatabaseProvider.db.getUser(user);
    }
    user = data[DatabaseProvider.COLUMN_DISPLAY_NAME].toString() == ''
        ? data[DatabaseProvider.COLUMN_EMAILS].toString()
        : data[DatabaseProvider.COLUMN_DISPLAY_NAME].toString();
    setState(() {
      bool status = prefs.getBool('entered');
      if (!status || status == null) {
        //data = temp;
        loading = false;
        entered = false;
      } else {
        //data = temp;
        entered = true;
        loading = false;
      }
    });
  }

  @override
  void initState() {
    data = widget.data;
    super.initState();
    if (data == null) {
      _display();
    } else {
      user = data[DatabaseProvider.COLUMN_EMAILS].join(',').toString();
      loading = false;
      entered = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (loading) {
      return LoadingScreen();
    }
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              /*"ENTER DISPLAY NAME for User:\n*/ "Logged In:\n$user",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size.height * 0.05),
            TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter display name for above user',
              ),
              controller: myController,
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                // When the user presses the button, show an alert dialog containing
                // the text that the user has entered into the text field.
                onPressed: () {
                  String name = myController.text.toString().trim();
                  if (name.length > 0) {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            // Retrieve the text the that user has entered by using the
                            // TextEditingController.
                            content: Text("Display Name:\n$name"),
                            actions: <Widget>[
                              new FlatButton(
                                  child: const Text("Confirm"),
                                  onPressed: () async {
                                    await updateName(name);
                                    await _setOid(true);
                                    await _setEntered(name);
                                    Navigator.pop(context);
                                  })
                            ]);
                      },
                    );
                  } else {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            // Retrieve the text the that user has entered by using the
                            // TextEditingController.
                            content: Text("Enter valid name"),
                            actions: <Widget>[
                              new FlatButton(
                                  child: const Text("Ok"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ]);
                      },
                    );
                  }
                },
                //tooltip: 'Name to be displayed on dashboard',
                child: Text("Done"), //Icon(Icons.arrow_forward),
              ),
            ),

            /*SvgPicture.asset(
              "assets/icons/stethescope.svg",
              height: size.height * 0.45,
            ),*/

            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "ACCEPT",
              press: () async {
                if (entered) {
                  await _setAccepted(true);
                  await _setOid(false);
                  Navigator.pushReplacementNamed(context, '/app0');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setAccepted(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('accepted', status);
    print("Accepted set");
    _deleteEntered();
    _deleteOid();
    print('prefs deleted');
  }

  Future<void> _setEntered(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('entered', true);
    print("Entered set");
    setState(() {
      entered = true;
      data = data;
      user = name;
      loading = false;
    });
  }

  Future<void> _setOid(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    if (status == true) {
      prefs.setString('nullOid', data[DatabaseProvider.COLUMN_OID].toString());
    } else {
      prefs.setString('nullOid', null);
    }
  }

  Future<void> updateName(String name) async {
    Map<String, String> user = {
      DatabaseProvider.COLUMN_OID: data[DatabaseProvider.COLUMN_OID].toString(),
      DatabaseProvider.COLUMN_DISPLAY_NAME: name
    };
    await DatabaseProvider.db.updateUser(user);
  }

  Future<void> _deleteEntered() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('entered');
  }

  Future<void> _deleteOid() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('nullOid');
  }
}
