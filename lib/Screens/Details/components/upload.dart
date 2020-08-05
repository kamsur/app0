import 'package:app0/Screens/User/components/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app0/components2/user.dart';
import 'package:app0/constants2.dart';

class Upload extends StatelessWidget {
  final User user;
  const Upload({Key key, this.user}) : super(key: key);

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
                  (user.type != CategoryList.CATEGORY_DESK) &&
                  (user.status != 'SAFE')) {}
            },
            icon: SvgPicture.asset(
              "assets/icons/log.svg",
              height: 18,
            ),
            label: Text(
              "Upload\nDaily Logs",
              style: TextStyle(color: Colors.white),
            ),
          ),
          //SizedBox(width: kDefaultPadding / 2),
          // it will cover all available spaces
          Spacer(),
          FlatButton.icon(
            onPressed: () {
              if (user.type != CategoryList.CATEGORY_FAMILY &&
                  (user.status != 'SAFE')) {}
            },
            icon: SvgPicture.asset(
              "assets/icons/health.svg",
              height: 18,
            ),
            label: Text(
              "Upload\nHealth Status",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
