import 'package:flutter/material.dart';
import 'package:app0/Screens/Loading/components/background.dart';
//import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOADING",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            /*SvgPicture.asset(
              "assets/icons/stethescope.svg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.05),*/
          ],
        ),
      ),
    );
  }
}
