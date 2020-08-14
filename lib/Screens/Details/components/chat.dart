import 'dart:async';
//import 'dart:convert';
//import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:app0/Internet/internet.dart';
import 'package:app0/constants2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app0/components2/user.dart';

//This is for Stateful Widget
class Chat extends StatefulWidget {
  final User user;
  const Chat({
    Key key,
    @required this.user,
  }) : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  User user;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: buildAppBar(context),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'https://kamsur.github.io/LazarusWeb/',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        );
      }),
    );
  }

/*
  _launchURL() async {
    const url = 'https://kamsur.github.io/LazarusWeb/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
*/
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          iconSize: 10,
          padding: EdgeInsets.only(left: kDefaultPadding / 2),
          icon: SvgPicture.asset("assets/icons/back.svg"),
          onPressed: () {
            Navigator.pop(context);
          }),
      centerTitle: true,
      title: Text(
        'LazarusWeb',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
