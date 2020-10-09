import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'upload_page.dart';
import 'comment_screen.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State {
  CollectionReference postcol =
      FirebaseFirestore.instance.collection('insta_posts');
  CollectionReference usercol =
      FirebaseFirestore.instance.collection('insta_users');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        floatingActionButton: FloatingActionButton(
          mini: true,
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Uploader())),
          child: Icon(Icons.add, size: 32),
        ),
        body: StreamBuilder(
            stream: postcol.snapshots(),
// ignore: missing_return
            builder: (context, snapshot) {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot same = snapshot.data.documents[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.black,
                          backgroundImage: NetworkImage(''),
                        ),
                        title: Text(
                          same['username'],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (same['number'] == 1)
                              Column(
                                children: [
                                  Text(
                                    same['description'],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Image(image: NetworkImage(same['mediaUrl'])),
                                ],
                              ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CommentScreen())),
                                      child: Icon(Icons.comment),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      same['commentcount'].toString(),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            }),
      );
    
  }
}
