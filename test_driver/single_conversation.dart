import 'package:flutter_driver/driver_extension.dart';

import '../lib/chat/single_conversation.dart' as app;

void main() async {
  enableFlutterDriverExtension();

  await app.main();
}
