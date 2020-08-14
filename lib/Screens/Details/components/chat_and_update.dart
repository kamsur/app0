import 'package:app0/Screens/Details/components/chat.dart';
import 'package:app0/Screens/Details/components/update.dart';
import 'package:app0/Screens/User/components/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app0/components2/user.dart';
import 'package:app0/constants2.dart';

class ChatAndUpdate extends StatelessWidget {
  final User user;
  const ChatAndUpdate({Key key, this.user}) : super(key: key);

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
                  (user.type != CategoryList.CATEGORY_DESK)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Chat(
                      user: user,
                    ),
                  ),
                );
              }
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
              if (user.type != CategoryList.CATEGORY_FAMILY) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Update(
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
              "Update\nProfile",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
