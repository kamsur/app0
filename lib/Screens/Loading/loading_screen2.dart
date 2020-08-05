import 'package:flutter/material.dart';
import 'package:app0/Screens/Loading/components/body.dart';
import 'package:app0/constants2.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingScreen extends StatelessWidget {
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
        backgroundColor: kPrimaryColor,
        body: Body(),
      ),
    );
  }
  /*return Scaffold(
      body: Body(),
    );
  }*/
}
