import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:flutter_apns/apns.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../autha/services/auth_service.dart' as autha;
import '../config.dart';
//import '../services/theme_changer.dart';
import '../tabs/categories_tab.dart';
import '../tabs/proconian_tab.dart';
import '../tabs/chat_tab.dart';
import '../../insta/insta_tab.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/services.dart';

import '../../autha/common_widgets/platform_alert_dialog.dart';
import '../../autha/common_widgets/platform_exception_alert_dialog.dart';
import '../../autha/constants/keys.dart';
import '../../autha/constants/strings.dart';
import '../../chat/all_channels.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: IndexedStack(
        index: currentIndex,
        children: <Widget>[
          ProconianTab(),
          CategoriesTab(),
          ChatTab(),
          InstaTab(),
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
            title: 'Chat',
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
