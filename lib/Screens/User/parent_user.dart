import 'package:flutter/material.dart';
import 'package:app0/Screens/User/components/user_body.dart';
import 'package:app0/constants2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app0/DB/database_provider.dart';
import 'package:app0/Screens/Welcome/components/body.dart';
//import 'package:path/path.dart';
import 'package:flutter_svg/svg.dart';

class ParentUser extends StatelessWidget {
  final AadOAuth oauthB2Ca = AadOAuth(Body.configB2Ca);
  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: ThemeData(
        // We set Poppins as our default font
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        primaryColor: kPrimaryColor,
        accentColor: kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      child: new Scaffold(
        appBar: buildAppBar(),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new ListTile(
                  title: new Text("Add User"),
                  leading: new Icon(Icons.add),
                  onTap: () {
                    Navigator.pop(context);
                    login(oauthB2Ca, context, 'F');
                  }),
              new ListTile(
                  title: new Text("Add Family"),
                  leading: new Icon(Icons.add),
                  onTap: () {
                    Navigator.pop(context);
                    login(oauthB2Ca, context, 'FB');
                  }),
              new ListTile(
                  title: new Text("Add Desk"),
                  leading: new Icon(Icons.add),
                  onTap: () {
                    Navigator.pop(context);
                    login(oauthB2Ca, context, 'D');
                  }),
              new ListTile(
                title: new Text("Close"),
                leading: new Icon(Icons.exit_to_app),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        backgroundColor: kPrimaryColor,
        body: UserBody(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text('Dashboard'),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset("assets/icons/notification.svg"),
          onPressed: () {},
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

  Future<void> login(AadOAuth oAuth, BuildContext context, String type) async {
    try {
      await oAuth.login();
      String accessToken = await oAuth.getAccessToken();
      int flag = 0;
      try {
        print('payloadMap: ${Body.parseJwtPayLoad(accessToken)}');
        await DatabaseProvider.db
            .setupDatabase(Body.parseJwtPayLoad(accessToken), type);
        await DatabaseProvider.db.registerFamily();
        flag = 1;
      } catch (e) {
        showError(e, context);
      }
      if (flag == 1) {
        //showMessage("Logged in successfully!", context);
        await oAuth.logout();
        await _setRejected(true);
        await _setEntered(false);
        Navigator.pushReplacementNamed(context, '/home',
            arguments: Body.parseJwtPayLoad(accessToken));
      }
    } catch (e) {
      showError(e, context);
    }
  }

  Future<void> _setRejected(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('accepted', !status);
    print("Rejected set");
  }

  Future<void> _setEntered(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('entered', status);
    print("Entered not set");
  }
}
