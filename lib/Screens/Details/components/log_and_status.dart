import 'package:app0/Screens/Details/components/status.dart';
import 'package:app0/Screens/Log/log_screen.dart';
import 'package:app0/Screens/User/components/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app0/components2/user.dart';
import 'package:app0/constants2.dart';

class LogAndStatus extends StatefulWidget {
  final Function(User) callback;
  final User user;
  LogAndStatus({Key key, @required this.user, this.callback}) : super(key: key);
  @override
  _LogAndStatusState createState() => _LogAndStatusState();
}

typedef void UserCallback(User value);

class _LogAndStatusState extends State<LogAndStatus> {
  User user;
  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(kDefaultPadding),
      padding: EdgeInsets.symmetric(
        //horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFFCBF1E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              if ((user.type != CategoryList.CATEGORY_FAMILY) &&
                  (user.type != CategoryList.CATEGORY_DESK)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogScreen(
                      user: user,
                    ),
                  ),
                );
              }
            },
            icon: SvgPicture.asset(
              "assets/icons/log.svg",
              height: 18,
            ),
            label: Text(
              "Write\nDaily Log",
              style: TextStyle(color: Colors.white),
            ),
          ),
          //SizedBox(width: kDefaultPadding / 2),
          // it will cover all available spaces
          Spacer(),
          FlatButton.icon(
            onPressed: () {
              if (user.type != CategoryList.CATEGORY_FAMILY) {
                Navigator.of(context)
                    .push(new MaterialPageRoute<User>(
                  builder: (context) => Status(user: user),
                ))
                    .then((User newUser) {
                  setState(() {
                    user = newUser;
                    widget.callback(newUser);
                  });
                });
              }
            },
            icon: SvgPicture.asset(
              "assets/icons/health.svg",
              height: 18,
            ),
            label: Text(
              "Change\nHealth Status",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
