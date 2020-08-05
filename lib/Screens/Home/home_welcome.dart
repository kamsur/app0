import 'package:flutter/material.dart';
import 'package:app0/Screens/Home/components/body.dart';

class HomeWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Body(data: data),
    );
  }
}
