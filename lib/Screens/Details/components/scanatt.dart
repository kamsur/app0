import 'package:app0/Screens/Details/components/attendance.dart';
import 'package:app0/Screens/User/components/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app0/components2/user.dart';
import 'package:app0/constants2.dart';

class ScanAtt extends StatelessWidget {
  final User user;
  const ScanAtt({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(kDefaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFFCBF1E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: <Widget>[
          FlatButton.icon(
            onPressed: () {
              if (user.type != CategoryList.CATEGORY_FAMILY) {
                Scanner(user: user);
              }
            },
            icon: SvgPicture.asset(
              "assets/icons/bluetooth.svg",
              height: 18,
            ),
            label: Text(
              "Start/Stop\nScan",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: kDefaultPadding / 2),
          // it will cover all available spaces
          Spacer(),
          FlatButton.icon(
            onPressed: () {
              if (user.type != CategoryList.CATEGORY_FAMILY) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Attendance(
                      user: user,
                    ),
                  ),
                );
              }
            },
            icon: SvgPicture.asset(
              "assets/icons/edit.svg",
              height: 30,
            ),
            label: Text(
              "Record\nAttendance",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
