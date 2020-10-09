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
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/services.dart';

import '../../autha/common_widgets/platform_alert_dialog.dart';
import '../../autha/common_widgets/platform_exception_alert_dialog.dart';
import '../../autha/constants/keys.dart';
import '../../autha/constants/strings.dart';
import '../../chat/all_channels.dart';
import '../../models.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  bool _isChatInitialized = false;

  final client = Client(
    'py32xzd3zebj',
    logLevel: Level.FINEST,
    //persistenceEnabled: true,
    //connectTimeout: Duration(milliseconds: 6000),
    //receiveTimeout: Duration(milliseconds: 6000),
  );

  @override
  void initState() {
    super.initState();
    print("###### initState home page....");
    _initializeAsyncDependencies();
  }

  Future<void> _initializeAsyncDependencies() async {
    print("###### initStreamChatClient....");
    /*
    final user = Provider.of<autha.User>(context);
    final userEmail = user.email;
    print("#######" + userEmail);
    */

    final user1 = User(
      id: 'peteryxu2020',
      role: 'admin',
      //extraData: details,
    );

    final devToken = client.devToken('peteryxu2020');
    print("####### got devToken, connecting" + devToken);

    await client.setUser(
      user1,
      devToken
    );
     print("######### DONE setUser");

    setState(() {
      _isChatInitialized = true;
    });
    print("######## setState ");
  }

  @override
  Widget build(BuildContext context) {
    //final themeChanger = Provider.of<ThemeChanger>(context);

    final user = Provider.of<AppUser>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Color(0xfffcba03),
        title: Text(TITLE),
        titleSpacing: 8.0,
        actions: <Widget>[
          FlatButton(
            key: Key(Keys.logout),
            child: Text(
              Strings.logout,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
          GestureDetector(
            child: Icon(Icons.lightbulb_outline),
            //onTap: themeChanger.toggle,
          )
        ],
      ),
      body: _buildBody(),
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

  Widget _buildBody() {
    if (_isChatInitialized) {
      return IndexedStack(
        index: currentIndex,
        children: <Widget>[
          ProconianTab(),
          CategoriesTab(),
          StreamChat(
            client: client,
            child: ChannelListPage(),
          ),
        ],
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final autha.AuthService auth =
          Provider.of<autha.AuthService>(context, listen: false);
      await auth.signOut();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: Strings.logoutFailed,
        exception: e,
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: Strings.logout,
      content: Strings.logoutAreYouSure,
      cancelActionText: Strings.cancel,
      defaultActionText: Strings.logout,
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }
}
