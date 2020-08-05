import 'package:flutter/material.dart';

import 'package:app0/constants2.dart';

// We need statefull widget because we are gonna change some state on our category
class CategoryList extends StatefulWidget {
  final Function(String) callback;
  CategoryList({this.callback});
  static const CATEGORY_PARENT = 'Parent';
  static const CATEGORY_OTHER_USER = 'User';
  static const CATEGORY_FAMILY = 'Family';
  static const CATEGORY_DESK = 'Desk';
  @override
  _CategoryListState createState() => _CategoryListState();
}

typedef void StringCallback(String value);

class _CategoryListState extends State<CategoryList> {
  // by default first item will be selected
  int selectedIndex = 0;
  List categories = [
    'All',
    CategoryList.CATEGORY_PARENT,
    CategoryList.CATEGORY_OTHER_USER,
    CategoryList.CATEGORY_FAMILY,
    CategoryList.CATEGORY_DESK
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
              widget.callback(categories[selectedIndex]);
            });
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: kDefaultPadding,
              // At end item it add extra 20 right  padding
              right: index == categories.length - 1 ? kDefaultPadding : 0,
            ),
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            decoration: BoxDecoration(
              color: index == selectedIndex
                  ? Colors.white.withOpacity(0.4)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              categories[index],
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
