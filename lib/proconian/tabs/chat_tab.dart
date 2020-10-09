import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../../chat/all_channels.dart';
import '../../autha/services/auth_service.dart';
import '../../models.dart';

class ChatTab extends StatefulWidget {
  ChatTab({Key key}) : super(key: key);

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  bool _isChatInitialized = false;

  final client = Client(
    'py32xzd3zebj',
    logLevel: Level.FINEST,
    //persistenceEnabled: true,
    //connectTimeout: Duration(milliseconds: 6000),
    //receiveTimeout: Duration(milliseconds: 6000),
  );

/*
When an inherited widget changes, for example if the value of Theme.of() changes, its dependent widgets are rebuilt. If the dependent widget's reference to the inherited widget is in a constructor or an initState() method, then the rebuilt dependent widget will not reflect the changes in the inherited widget.
Typically references to inherited widgets should occur in widget build() methods. 
Alternatively, initialization based on inherited widgets can be placed in the didChangeDependencies method, which is called after initState and whenever the dependencies change thereafter.

Every time a State object’s setState() function is called, its build() function will be called soon after,
to rebuild the widgets


*/
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("######ChatTab didChangeDependencies");
    _initializeAsyncDependencies();
  }

  @override
  void initState() {
    super.initState();
    print("######ChatTab initState");
    //_initializeAsyncDependencies();
  }

  Future<void> _initializeAsyncDependencies() async {
    print(
        "######ChatTab init StreamChatClient using logged in useremail as id.");

    final user = Provider.of<AppUser>(context);
    final userEmail = user.email;
    print("#######ChatTab " + userEmail);

    //valid user id. a-z, 0-9, @, _ and - are allowed:
    final userID = userEmail.replaceAll('.', '_');
    print("#######ChatTab " + userID);

    /*final user1 = User(
      id: 'peteryxu2020',
      role: 'admin',
      //extraData: details,
    ); */

    final user1 = User(
      id: userID,
      role: 'user',
      //extraData: details,
    );

    final devToken = client.devToken(userID);
    print("####### got devToken, connecting" + devToken);

    await client.setUser(user1, devToken);
    print("######### DONE setUser");

    setState(() {
      _isChatInitialized = true;
    });
    print("######## setState ");
  }

  @override
  Widget build(BuildContext context) {
    return _isChatInitialized
        ? MaterialApp(
            builder: (context, child) => StreamChat(
              client: client,
              child: child,
            ),
            home: ChannelListPage(),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  /*
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Channels'),
      ),
      body: _isChatInitialized
          ? StreamChat(
              client: client,
              child: ChannelListPage(),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
  */

}
