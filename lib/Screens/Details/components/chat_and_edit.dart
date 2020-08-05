import 'package:app0/Screens/User/components/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app0/components2/user.dart';
import 'package:app0/constants2.dart';

class ChatAndEdit extends StatelessWidget {
  final User user;
  const ChatAndEdit({Key key, this.user}) : super(key: key);

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
              if ((user.type != CategoryList.CATEGORY_FAMILY) &&
                  (user.type != CategoryList.CATEGORY_DESK)) {}
            },
            icon: SvgPicture.asset(
              "assets/icons/chat.svg",
              height: 18,
            ),
            label: Text(
              "Talk to\nHealthBot",
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: kDefaultPadding / 2),
          // it will cover all available spaces
          Spacer(),
          FlatButton.icon(
            onPressed: () {
              if (user.type != CategoryList.CATEGORY_FAMILY) {}
            },
            icon: SvgPicture.asset(
              "assets/icons/edit.svg",
              height: 30,
            ),
            label: Text(
              "Edit Profile",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
