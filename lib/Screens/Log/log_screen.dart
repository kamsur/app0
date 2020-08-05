import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app0/constants2.dart';
import 'package:app0/components2/user.dart';
import 'package:app0/Screens/Log/components/body.dart';

class LogScreen extends StatelessWidget {
  final User user;

  const LogScreen({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: buildAppBar(context),
      body: Body(user: user),
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
          Navigator.pop(context);
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
