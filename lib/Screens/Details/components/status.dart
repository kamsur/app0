import 'dart:ui';

import 'package:app0/constants2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app0/components2/user.dart';

//import '../details_screen.dart';
//import 'package:aad_oauth/aad_oauth.dart';

//This is for Stateful Widget
class Status extends StatefulWidget {
  final User user;
  const Status({
    Key key,
    @required this.user,
  }) : super(key: key);
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  User user;
  String newStatus = '';
  //User newUser;

  @override
  void initState() {
    user = widget.user;
    if (newStatus == '') {
      newStatus = user.status;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.of(context).pop(user);
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: buildAppBar(context),
        body: Container(
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
                  'Choose your Health status',
                  style: Theme.of(context).textTheme.button,
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('SAFE'),
                        leading: Radio(
                          value: 'SAFE',
                          groupValue: newStatus,
                          onChanged: (value) {
                            setState(() {
                              newStatus = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Symptomatic'),
                        leading: Radio(
                          value: 'Symptomatic',
                          groupValue: newStatus,
                          onChanged: (value) {
                            setState(() {
                              newStatus = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Came in infected\'s contact'),
                        leading: Radio(
                          value: 'Risky',
                          groupValue: newStatus,
                          onChanged: (value) {
                            setState(() {
                              newStatus = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Infected'),
                        leading: Radio(
                          value: 'Infected',
                          groupValue: newStatus,
                          onChanged: (value) {
                            setState(() {
                              newStatus = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: FlatButton(
                    // When the user presses the button, show an alert dialog containing
                    // the text that the user has entered into the text field.
                    onPressed: () {
                      if (newStatus != user.status) {
                        print('newStatus: $newStatus');
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  // Retrieve the text the that user has entered by using the
                                  // TextEditingController.
                                  content: Text("Confirm Status Change\?"),
                                  actions: <Widget>[
                                    new FlatButton(
                                        child: const Text("Confirm"),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          //Navigator.of(context).pop(newUser);
                                          User temp = await changeStatus(
                                              user, newStatus);
                                          setState(() {
                                            //newUser = temp;
                                            user = temp;
                                          });

                                          /*Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsScreen(
                                                      user: newUser,
                                                    )));*/
                                        }),
                                  ]);
                            });
                      } else {
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                // Retrieve the text the that user has entered by using the
                                // TextEditingController.
                                content: Text("Change status first"),
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
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kBackgroundColor,
      elevation: 0,
      leading: IconButton(
        iconSize: 10,
        padding: EdgeInsets.only(left: kDefaultPadding / 2),
        icon: SvgPicture.asset("assets/icons/back.svg"),
        onPressed: () {
          Navigator.of(context).pop(user);
          /*newUser != null
              ? Navigator.of(context).pop(newUser)
              : Navigator.of(context).pop(user);*/
          /*Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailsScreen(
                        user: user,
                      )));*/
        },
      ),
      centerTitle: false,
      title: Text(
        'Back'.toUpperCase(),
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
