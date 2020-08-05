import 'package:flutter/material.dart';
import 'package:app0/Screens/Loading/loading_screen2.dart';
import 'package:app0/Screens/User/components/category_list.dart';
import 'package:app0/Screens/User/components/user_card.dart';
import 'package:app0/Screens/Details/details_screen.dart';
import 'package:app0/components2/search_box.dart';
import 'package:app0/components2/user.dart';
import 'package:app0/constants2.dart';
import 'package:app0/DB/database_provider.dart';
//import 'package:app0/Bluetooth/bleScan.dart';

//This is for Stateful Widget
class UserBody extends StatefulWidget {
  @override
  _UserBodyState createState() => _UserBodyState();
}

class _UserBodyState extends State<UserBody> {
  //final AadOAuth oauthB2Ca = AadOAuth(Body.configB2Ca);
  List users = [];
  //List desks = [];
  List current = [];
  bool loading = true;

  Future<void> _display(String value) async {
    List temp = await DatabaseProvider.db.getUsers();
    setState(() {
      users = temp;
      _listDisplay(value);
      loading = false;
    });
  }

  void _listDisplay(String value) {
    current.clear();
    print('Value:$value');
    print('CurrentClear:$current');
    print('Users:$users');
    if (value == "All") {
      current = users;
    } else if (value == CategoryList.CATEGORY_PARENT) {
      List temp = [];
      for (final element in users) {
        if (element[DatabaseProvider.COLUMN_TYPE] == 'Parent') {
          temp.add(element);
          break;
        }
      }
      print('Temp:$temp');
      current = temp;
    } else if (value == CategoryList.CATEGORY_OTHER_USER) {
      List temp = [];
      for (final element in users) {
        if (element[DatabaseProvider.COLUMN_TYPE] == 'Family') {
          temp.add(element);
        }
      }
      print('Temp:$temp');
      current = temp;
    } else if (value == CategoryList.CATEGORY_FAMILY) {
      List temp = [];
      for (final element in users) {
        if (element[DatabaseProvider.COLUMN_TYPE] == 'FamilyB') {
          temp.add(element);
        }
      }
      print('Temp:$temp');
      current = temp;
    } else {
      List temp = [];
      for (final element in users) {
        if (element[DatabaseProvider.COLUMN_TYPE] == 'Desk') {
          temp.add(element);
        }
      }
      print('Temp:$temp');
      current = temp;
    }
    print("Current:$current");
  }

  @override
  void initState() {
    super.initState();
    _display('All');
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return LoadingScreen();
    }
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          SearchBox(onChanged: (value) {}),
          CategoryList(
              callback: (value) => setState(() {
                    _display(value);
                  })),
          SizedBox(height: kDefaultPadding / 2),
          Expanded(
            child: Stack(children: <Widget>[
              // Our background
              Container(
                margin: EdgeInsets.only(top: 70),
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
              ),
              ListView.builder(
                // here we use our users list
                itemCount: current.length,
                itemBuilder: (context, index) => UserCard(
                    itemIndex: index,
                    user: toUser(current[index]),
                    press: () {
                      User temp = toUser(current[index]);
                      Navigator.of(context)
                          .push(new MaterialPageRoute<String>(
                        builder: (context) => DetailsScreen(user: temp),
                      ))
                          .then((String value) {
                        if (value != '') {
                          setState(() {
                            _display('All');
                          });
                        }
                      });
                      /*Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                            user: toUser(current[index]),
                          ),*/
                    }),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
