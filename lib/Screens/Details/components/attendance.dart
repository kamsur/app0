import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:app0/DB/database_provider.dart';
//import 'package:app0/Internet/internet.dart';
import 'package:app0/components2/qr_gen.dart';
import 'package:app0/constants2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app0/components2/user.dart';

//import '../details_screen.dart';
//import 'package:aad_oauth/aad_oauth.dart';

//This is for Stateful Widget
class Attendance extends StatefulWidget {
  final User user;
  const Attendance({
    Key key,
    @required this.user,
  }) : super(key: key);
  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  User user;
  String choice = '';
  //StreamSubscription _connectionChangeStream;
  bool isOffline = false;

  static final Config configB2Cb = new Config(
      "93ea5ca9-6dbc-4e15-99d1-2ae0d20b19a9",
      "ccfd9597-76f1-4246-8f5c-7bca14013308",
      "ccfd9597-76f1-4246-8f5c-7bca14013308 offline_access",
      "https://barqat.b2clogin.com/oauth2/nativeclient",
      clientSecret: null,
      isB2C: true,
      azureTenantName: "barqat",
      userFlow: "B2C_1_SU_2",
      tokenIdentifier: "UNIQUE IDENTIFIER B");
  final AadOAuth oauthB2Cb = AadOAuth(configB2Cb);

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
    var rectSize = Rect.fromLTWH(0.0, 25.0, size.width, size.height - 25);
    oauthB2Cb.setWebViewScreenSize(rectSize);
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: buildAppBar(context),
        body: Container(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              Text(
                'User : ${user.displayName}',
                style: Theme.of(context).textTheme.button,
              ),
              SizedBox(height: size.height * 0.05),
              Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: const Text('Scan QR'),
                      leading: Radio(
                        value: 'A',
                        groupValue: choice,
                        onChanged: (value) {
                          setState(() {
                            choice = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Show QR'),
                      leading: Radio(
                        value: 'B',
                        groupValue: choice,
                        onChanged: (value) {
                          setState(() {
                            choice = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Sign In'),
                      leading: Radio(
                        value: 'C',
                        groupValue: choice,
                        onChanged: (value) {
                          setState(() {
                            choice = value;
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
                child: RaisedButton(
                  // ignore: missing_return
                  onPressed: () {
                    print('choice: $choice');
                    switch (choice) {
                      case 'A':
                        break;
                      case 'B':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QrGen(
                              user: user,
                            ),
                          ),
                        );
                        break;
                      case 'C':
                        /*if (isOffline) {
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
                        } else*/
                        {
                          login(oauthB2Cb, context, user.oid);
                        }
                        break;
                      default:
                        break;
                    }
                  },
                  color: kSecondaryColor,
                  child: Text(
                    "Go",
                    style: Theme.of(context).textTheme.button,
                  ), //Icon(Icons.arrow_forward),
                ),
              ),
            ]))));
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
            Navigator.pop(context);
          }),
      centerTitle: false,
      title: Text(
        'Back'.toUpperCase(),
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  void showError(dynamic ex, BuildContext context) {
    showMessage(ex.toString(), context);
  }

  void showMessage(String text, BuildContext context) {
    //final context = navigatorKey.currentState.overlay.context;
    var alert = new AlertDialog(content: new Text(text), actions: <Widget>[
      new FlatButton(
          child: const Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  Future<void> login(AadOAuth oAuth, BuildContext context, String oid) async {
    try {
      await oAuth.login();
      String accessToken = await oAuth.getAccessToken();
      int flag = 0;
      try {
        await DatabaseProvider.db
            .logAttendance(parseJwtPayLoad(accessToken), oid);
        flag = 1;
      } catch (e) {
        showError(e, context);
      }
      if (flag == 1) {
        //showMessage("Logged in successfully!", context);
        await oAuth.logout();
        print('Logged out');
      }
    } catch (e) {
      showError(e, context);
    }
  }

  Map<String, dynamic> parseJwtPayLoad(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }
    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}
