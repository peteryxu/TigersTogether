import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'feed.dart';
import 'feed2.dart';
import 'upload_page.dart';
import 'dart:async';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'activity_feed.dart';
import 'create_account.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import '../models.dart';
import '../autha/services/auth_service.dart';
import 'package:provider/provider.dart';

//final auth = FirebaseAuth.instance;
//final googleSignIn = GoogleSignIn();
final ref = FirebaseFirestore.instance.collection('insta_users');
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

AppUser currentUserModel;


Future<Null> _setUpNotifications() async {
  if (Platform.isAndroid) {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );

    _firebaseMessaging.getToken().then((token) {
      print("Firebase Messaging Token: " + token);

      FirebaseFirestore.instance
          .collection("insta_users")
          .document(currentUserModel.id)
          .updateData({"androidNotificationToken": token});
    });
  }
}


class InstaTab extends StatefulWidget {
  InstaTab({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _InstaTabState createState() => _InstaTabState();
}

PageController pageController;

class _InstaTabState extends State<InstaTab> {
  int _page = 0;
  bool triedSilentLogin = false;
  bool setupNotifications = false;

// final autha.AuthService auth = Provider.of<autha.AuthService>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    /*
    if (triedSilentLogin == false) {
      silentLogin(context);
    }

    if (setupNotifications == false && currentUserModel != null) {
      setUpNotifications();
    }
    */

    
    final  AppUser appUser =Provider.of<AppUser>(context, listen: false);

    return Scaffold(
      body: PageView(
        children: [
          Container(
            color: Colors.white,
            child: Feed2(),
          ),
          Container(color: Colors.white, child: SearchPage()),
          Container(
            color: Colors.white,
            child: Uploader(),
          ),
          Container(color: Colors.white, child: ActivityFeedPage()),
          Container(
              color: Colors.white,
              child: ProfilePage(
                userId: appUser.id,
              )),
        ],
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: (_page == 0) ? Colors.black : Colors.grey),
              title: Container(height: 0.0),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: (_page == 1) ? Colors.black : Colors.grey),
              title: Container(height: 0.0),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle,
                  color: (_page == 2) ? Colors.black : Colors.grey),
              title: Container(height: 0.0),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.star,
                  color: (_page == 3) ? Colors.black : Colors.grey),
              title: Container(height: 0.0),
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: (_page == 4) ? Colors.black : Colors.grey),
              title: Container(height: 0.0),
              backgroundColor: Colors.white),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }

  

  void setUpNotifications() {
    _setUpNotifications();
    setState(() {
      setupNotifications = true;
    });
  }

  

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
}
