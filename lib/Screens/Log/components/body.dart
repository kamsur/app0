//import 'dart:async';
import 'dart:ui';

import 'package:app0/Cloud/barqat_luis.dart';
//import 'package:app0/Internet/internet.dart';
import 'package:app0/constants2.dart';
import 'package:flutter/material.dart';
import 'package:app0/Screens/Log/components/background.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:app0/components2/user.dart';
import 'package:app0/DB/database_provider.dart';
//import 'package:aad_oauth/aad_oauth.dart';

//This is for Stateful Widget
class Body extends StatefulWidget {
  final User user;
  const Body({
    Key key,
    @required this.user,
  }) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  User user;
  DateTime _dateTime;
  final myController = TextEditingController();
  //StreamSubscription _connectionChangeStream;

  bool isOffline = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    user = widget.user;
    super.initState();
    /*ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);*/
  }

  /*void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'User:${user.displayName}',
              style: Theme.of(context).textTheme.button,
            ),
            SizedBox(height: size.height * 0.05),
            Text(
              _dateTime == null
                  ? 'Nothing has been picked yet'
                  : _dateTime.toString(),
              style: Theme.of(context).textTheme.button,
            ),
            RaisedButton(
              child: Text(
                'Pick a date',
                style: Theme.of(context).textTheme.button,
              ),
              color: kSecondaryColor,
              onPressed: () {
                showDatePicker(
                        context: context,
                        initialDate:
                            _dateTime == null ? DateTime.now() : _dateTime,
                        firstDate: DateTime(2019),
                        lastDate: DateTime(2022))
                    .then((date) {
                  setState(() {
                    _dateTime = date;
                    myController.text = myController.text;
                  });
                });
              },
            ),
            SizedBox(height: size.height * 0.05),
            Container(
              margin: EdgeInsets.all(8.0),
              // hack textfield height
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: TextField(
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter log on chosen date',
                ),
                style: Theme.of(context).textTheme.button,
                controller: myController,
                maxLength: 250,
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: RaisedButton(
                // When the user presses the button, show an alert dialog containing
                // the text that the user has entered into the text field.
                onPressed: () {
                  String utterance = myController.text.toString().trim();
                  if (utterance.length > 0 && _dateTime != null) {
                    if (!isOffline) {
                      return showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              // Retrieve the text the that user has entered by using the
                              // TextEditingController.
                              content: Text("Save Log\?"),
                              actions: <Widget>[
                                new FlatButton(
                                    child: const Text("Confirm"),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      String log = await BarqatLUIS.luis
                                          .getResponse(utterance);
                                      print("LOG0:$log");
                                      if (log != '') {
                                        await DatabaseProvider.db.updateLog(
                                            user.oid, log, _dateTime);
                                        myController.clear();
                                        print("Controller cleared");
                                      }
                                    })
                              ]);
                        },
                      );
                    } else {
                      return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                content: Text("Check Internet connection!"),
                                actions: <Widget>[
                                  new FlatButton(
                                      child: const Text("Ok"),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      }),
                                ]);
                          });
                    }
                  } else {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            // Retrieve the text the that user has entered by using the
                            // TextEditingController.
                            content: Text("Enter valid log and date"),
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
                color: kSecondaryColor,
                child: Text(
                  "Done",
                  style: Theme.of(context).textTheme.button,
                ), //Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
