import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../config.dart';
import '../model/post_entity.dart';
import '../pages/single_category.dart';
import '../widgets/featured_category_list.dart';
import '../widgets/posts_list.dart';

import '../../autha/services/auth_service.dart' as autha;
import '../../autha/common_widgets/platform_alert_dialog.dart';
import '../../autha/common_widgets/platform_exception_alert_dialog.dart';
import '../../autha/constants/keys.dart';
import '../../autha/constants/strings.dart';
import 'package:provider/provider.dart';


class ProconianTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Color(0xfffcba03),
        title: Text("Proconian"),
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
        body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Container(
              //   height: 125.0,
              //   width: MediaQuery.of(context).size.width,
              //   child: Center(
              //       child: Text(
              //     TITLE,
              //     style: TextStyle(
              //         color: Colors.black,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 30),
              //   )),
              //   decoration: new BoxDecoration(
              //     color: Color(0xfffcba03),
              //     boxShadow: [new BoxShadow(blurRadius: 30.0)],
              //     borderRadius: new BorderRadius.vertical(
              //         bottom: new Radius.elliptical(
              //             MediaQuery.of(context).size.width, 50.0)),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              ListHeading(FEATURED_CATEGORY_TITLE, FEATURED_CATEGORY_ID),
              Container(
                height: 250.0,
                child: FeaturedCategoryList(),
              ),
              ListHeading('Latest', 0),
              Flexible(
                fit: FlexFit.loose,
                child: PostsList(),
              ),
            ],
          ),
        ),
      ),
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

class ListHeading extends StatelessWidget {
  final String title;
  final int categoryId;

  ListHeading(this.title, this.categoryId);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.display1,
          ),
          GestureDetector(
            onTap: () {
              PostCategory category = PostCategory(name: title, id: categoryId);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleCategory(category)));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Theme.of(context).textSelectionColor),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Text('Show All'),
            ),
          )
        ],
      ),
    );
  }

  
}
