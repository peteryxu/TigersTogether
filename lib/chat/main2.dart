import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  /*
  final client = Client(
    'b67pax5b2wdq',
    logLevel: Level.INFO,
  );

  await client.setUser(
    User(
      id: 'proud-night-8',
      extraData: {
        'image': 'https://getstream.io/random_png/?id=proud-night-8&amp;name=Proud+night',
      },
    ),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoicHJvdWQtbmlnaHQtOCJ9.CmUCsHM5qoaHdptiWciSEnw-4aLaL6qcuRqcG_Z4T40',
  );
  */

  final client = Client(
    'py32xzd3zebj',
    logLevel: Level.FINEST,
    persistenceEnabled: true,
    connectTimeout: Duration(milliseconds: 6000),
    receiveTimeout: Duration(milliseconds: 6000),
  );

  var details = {
    'name': 'Dev WeSense',
    'image':
        'https://lh3.google.com/u/0/ogw/ADGmqu_zxS25ikYtfO5ZQXZpOkI0BRu55jKtN2k0TbsN=s192-c-mo'
  };

  final user = User(
    id: 'peteryxu2020',
    role: 'role',
    //extraData: details,
  );

  final token = client.devToken('peteryxu2020');
  print("##################token is: " + token);

  await client.setUser(
    user,
    token,
  );

  /*
  var details = {
    'name': 'Sammy Xu',
    'image': '<a href="https://getstream.io/random_svg/?name=sammyxu" target="_self">https://i.imgur.com/fR9Jz14.png</a>'
  };

  final user = User(
    id: 'sammyxu2020',
    extraData: details,
  );

  await client.setUser(
    user,
    client.devToken('sammyxu2020'),
  );
  */

  //final channel = client.channel('messaging', id: 'messaging-channel1');
  final channel2 = client.channel('team', id: 'class-ap-language-art');
  //final channel3 = client.channel('team', id: 'class-american-history');
  //final channel4 = client.channel('team', id: 'class-ap-computer-science');
  //final channel5 = client.channel('team', id: 'club-stem');
  //final channel6 = client.channel('team', id: 'club-debate');

  //final channel7 = client.channel('livestream', id: 'Sports-Football Games');
  //final channel8 = client.channel('livestream', id: 'Sports-Basketball Games');

  // ignore: unawaited_futures
  channel2.watch();

  runApp(MyApp(client, channel2));
}

class MyApp extends StatelessWidget {
  final Client client;
  final Channel channel;

  MyApp(this.client, this.channel);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamChat(
        client: client,
        child: StreamChannel(
          channel: channel,
          child: ChannelPage(),
        ),
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(),
          ),
          MessageInput(),
        ],
      ),
    );
  }
}
