//import 'package:app0/Bluetooth/bleScan.dart';
import 'package:app0/Bluetooth/bleScan.dart';
import 'package:app0/Screens/Details/components/attendance.dart';
import 'package:app0/Screens/User/components/category_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app0/components2/user.dart';
import 'package:app0/constants2.dart';

class ScanAtt extends StatefulWidget {
  final User user;
  const ScanAtt({Key key, @required this.user}) : super(key: key);

  @override
  _ScanAttState createState() => _ScanAttState();
}

class _ScanAttState extends State<ScanAtt> {
  User user;
  bool toggleValue;
  @override
  void initState() {
    user = widget.user;
    toggleValue = Bluetooth.ble.isActive(user.oid);
    super.initState();
  }

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
          AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            height: 20.0,
            width: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: toggleValue
                  ? Colors.greenAccent[100]
                  : Colors.redAccent[200].withOpacity(0.5),
            ),
            child: Stack(
              children: <Widget>[
                AnimatedPositioned(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                    top: 3.0,
                    left: toggleValue ? 30.0 : 0.0,
                    right: toggleValue ? 0.0 : 30.0,
                    child: InkWell(
                      onTap: () async {
                        if (user.type != CategoryList.CATEGORY_FAMILY) {
                          Bluetooth.ble.scan(user.oid, context);
                          await Future.delayed(Duration(milliseconds: 1500));
                          setState(() {
                            toggleValue = Bluetooth.ble.isActive(user.oid);
                          });
                        }
                      },
                      child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 1000),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return RotationTransition(
                                child: child, turns: animation);
                          },
                          child: toggleValue
                              ? Icon(Icons.bluetooth_searching,
                                  color: Colors.green[600],
                                  size: 17.5,
                                  key: UniqueKey())
                              : Icon(Icons.bluetooth_disabled,
                                  color: Colors.green[600],
                                  size: 17.5,
                                  key: UniqueKey())),
                    )),
              ],
            ),
          ),
          /*
          FlatButton.icon(
            onPressed: () {
              if (user.type != CategoryList.CATEGORY_FAMILY) {
                Bluetooth.ble.scan(user.oid, context);
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
          ),*/
          Text(
            "Start/Stop\nScan",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: kDefaultPadding / 2),
          // it will cover all available spaces
          Spacer(),
          FlatButton.icon(
            onPressed: () {
              if (widget.user.type != CategoryList.CATEGORY_FAMILY) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Attendance(
                      user: widget.user,
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
