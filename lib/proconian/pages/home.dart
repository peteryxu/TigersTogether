import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../services/theme_changer.dart';
import '../tabs/categories_tab.dart';
import '../tabs/home_tab.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Color(0xfffcba03),
        title: Text(TITLE),
        titleSpacing: 8.0,
        actions: <Widget>[
          GestureDetector(
            child: Icon(Icons.lightbulb_outline),
            onTap: themeChanger.toggle,
          )
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: <Widget>[
          HomeTab(),
          CategoriesTab(),
        ],
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Color(0xfffcba03),
        color: Colors.black,
        activeColor: Colors.black,
        style: TabStyle.react,
        initialActiveIndex: currentIndex,

        // currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          TabItem(
            icon: Icon(
              Icons.home,
              size: 30,
              color: Colors.black,
            ),
            title: 'Home',
          ),
          TabItem(
            icon: Icon(
              Icons.category,
              size: 30,
              color: Colors.black,
            ),
            title: 'Categories',
          ),
           TabItem(
            icon: Icon(
              Icons.category,
              size: 30,
              color: Colors.black,
            ),
            title: 'Chats',
          ),
           TabItem(
            icon: Icon(
              Icons.category,
              size: 30,
              color: Colors.black,
            ),
            title: 'Feeds',
          ),
        ],
      ),
    );
  }
}
