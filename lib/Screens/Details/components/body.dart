import 'package:flutter/material.dart';
import 'package:app0/constants2.dart';
import 'package:app0/components2/user.dart';

import 'chat_and_update.dart';
import 'log_and_status.dart';
import 'user_image.dart';
import 'scanatt.dart';
import 'upload.dart';

//This is for Stateful Widget
class Body extends StatefulWidget {
  final User user;
  final Function(User) callback;
  const Body({Key key, @required this.user, this.callback}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

typedef void UserCallback(User value);

class _BodyState extends State<Body> {
  User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    //_setUser();
  }

  @override
  Widget build(BuildContext context) {
    // it provide us total height and width
    Size size = MediaQuery.of(context).size;
    // it enable scrolling on small devices
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              decoration: BoxDecoration(
                color: kBackgroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Hero(
                      tag: '${user.oid}',
                      child: UserPoster(
                        size: size,
                        image: user.image,
                      ),
                    ),
                  ),
                  LogAndStatus(
                      user: user,
                      callback: (newUser) => setState(() {
                            user = newUser;
                            widget.callback(newUser);
                          })),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kDefaultPadding / 2),
                    child: Text(
                      user.displayName,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Text(
                    '${user.status}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kSecondaryColor,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                    child: Text(
                      user.type,
                      style: TextStyle(color: kTextLightColor),
                    ),
                  ),
                  SizedBox(height: kDefaultPadding),
                ],
              ),
            ),
            ChatAndUpdate(user: user),
            ScanAtt(user: user),
            Upload(user: user),
          ],
        ),
      ),
    );
  }
}
