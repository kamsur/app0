import 'dart:async';
import 'dart:ui';

import 'package:app0/DB/database_provider.dart';
import 'package:app0/Screens/Loading/loading_screen2.dart';
import 'package:app0/constants2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app0/components2/user.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGen extends StatefulWidget {
  final User user;
  const QrGen({
    Key key,
    @required this.user,
  }) : super(key: key);
  @override
  _QrGenState createState() => _QrGenState();
}

class _QrGenState extends State<QrGen> {
  User user;
  bool loading = true;
  String uuid = '';
  int duration = 0;
  var timer;

  void _display() async {
    String temp = await DatabaseProvider.db.getUUIDAtDate(user.oid);
    DateTime now = DateTime.now().toUtc();
    setState(() {
      uuid = temp;
      loading = false;
      duration = (10 - now.minute.remainder(10)) * 60 - now.second;
    });
  }

  @override
  void initState() {
    user = widget.user;
    super.initState();
    _display();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (loading) {
      return LoadingScreen();
    }
    final side = size.width - 2 * kDefaultPadding;
    timer = Timer(
        Duration(seconds: duration),
        () => {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => QrGen(user: user)))
            });
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        if (timer != null) {
          timer.cancel();
          print('Timer cancelled');
        }
        Navigator.of(context).pop(user);
      },
      child: Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: buildAppBar(context),
          body: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.05),
              Container(
                child: CustomPaint(
                  size: Size.square(side),
                  painter: QrPainter(
                    data: uuid,
                    version: QrVersions.auto,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              ),
            ],
          ))),
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
            if (timer != null) {
              timer.cancel();
              print('Timer cancelled');
            }
            Navigator.pop(context);
          }),
      centerTitle: false,
      title: Text(
        'Back'.toUpperCase(),
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
