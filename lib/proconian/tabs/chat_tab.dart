import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../../chat/all_channels.dart';


class ChatTab extends StatelessWidget {
  final Client client;

  // ignore: public_member_api_docs
  ChatTab(this.client);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      builder: (context, widget) {
        return StreamChat(
          child: widget,
          client: client,
        );
      },
      home: ChannelListPage(),
    );
  }
}