import 'package:flutter/material.dart';

import '../config.dart';
import '../model/post_entity.dart';
import '../pages/single_category.dart';
import '../widgets/featured_category_list.dart';
import '../widgets/posts_list.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
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
