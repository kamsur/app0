import 'dart:ui';

import 'package:app0/Screens/Loading/loading_screen2.dart';
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
  bool loading = true;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (loading) {
      return LoadingScreen();
    }
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: buildAppBar(context),
        body: Container(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              Text(
                '',
                style: Theme.of(context).textTheme.button,
              ),
              SizedBox(height: size.height * 0.05),
              Container(),
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
}
