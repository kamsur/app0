import 'package:app0/Screens/User/components/category_list.dart';
//import 'package:app0/Screens/User/parent_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app0/constants2.dart';
import 'package:app0/components2/user.dart';
import 'components/body.dart';
//import 'package:aad_oauth/aad_oauth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app0/DB/database_provider.dart';

class DetailsScreen extends StatefulWidget {
  final User user;
  final Function(User) callback;

  const DetailsScreen({Key key, @required this.user, this.callback})
      : super(key: key);
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

typedef void UserCallback(User value);

class _DetailsScreenState extends State<DetailsScreen> {
  User user;
  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: buildAppBar(context),
      body: Body(
        user: user,
        callback: (newUser) => setState(() {
          user = newUser;
        }),
      ),
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
          Navigator.of(context).pop('All');
          /*Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ParentUser()));*/
        },
      ),
      centerTitle: false,
      title: Text(
        'Back'.toUpperCase(),
        style: Theme.of(context).textTheme.bodyText2,
      ),
      actions: <Widget>[
        IconButton(
          color: Theme.of(context).accentColor,
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            Navigator.of(context).pop('');
            logout(context);
          },
        ),
      ],
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
            //Navigator.pop(context);
          })
    ]);
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  Future<void> logout(BuildContext context) async {
    try {
      //await oAuth.logout();
      int flag = 0;
      try {
        await DatabaseProvider.db.deleteOid(user.oid);
        await DatabaseProvider.db.registerFamily();
        if (user.type == CategoryList.CATEGORY_PARENT) {
          await _setRejected(true);
          await _setLoggedOut(true);
        }
        print("Logged Out");
        flag = 1;
      } catch (e) {
        showError(e, context);
      }
      if (flag == 1) {
        //showMessage("Logged out", context);
        if (user.type == CategoryList.CATEGORY_PARENT) {
          Navigator.pushReplacementNamed(context, '/app0');
        } else {
          Navigator.pushReplacementNamed(context, '/user');
        }
      }
    } catch (e) {
      showError(e, context);
    }
  }

  Future<void> _setLoggedOut(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', !status);
    print("Logged Out set");
  }

  Future<void> _setRejected(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('accepted', !status);
    print("Rejected set");
  }
}
