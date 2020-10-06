import './autha/app/auth_widget_builder.dart';
import './autha/app/email_link_error_presenter.dart';
import './autha/app/auth_widget.dart';
import './autha/services/apple_sign_in_available.dart';
import './autha/services/auth_service.dart';
import './autha/services/auth_service_adapter.dart';
import './autha/services/firebase_email_link_handler.dart';
import './autha/services/email_secure_store.dart';
import './proconian/services/theme_changer.dart';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appleSignInAvailable = await AppleSignInAvailable.check();

  runApp(MyApp(appleSignInAvailable: appleSignInAvailable));
}

class MyApp extends StatelessWidget {
  // [initialAuthServiceType] is made configurable for testing
  const MyApp(
      {this.initialAuthServiceType = AuthServiceType.firebase,
      this.appleSignInAvailable});
  final AuthServiceType initialAuthServiceType;
  final AppleSignInAvailable appleSignInAvailable;

  @override
  Widget build(BuildContext context) {
    // MultiProvider for top-level services that can be created right away
    return MultiProvider(
      providers: [
        Provider<AppleSignInAvailable>.value(value: appleSignInAvailable),

        /*Provider<ThemeChanger>(
          create: (_) => ThemeChanger(),
        ), */
        
        Provider<AuthService>(
          create: (_) => AuthServiceAdapter(
            initialAuthServiceType: initialAuthServiceType,
          ),
          dispose: (_, AuthService authService) => authService.dispose(),
        ),
        Provider<EmailSecureStore>(
          create: (_) => EmailSecureStore(
            flutterSecureStorage: FlutterSecureStorage(),
          ),
        ),
        ProxyProvider2<AuthService, EmailSecureStore, FirebaseEmailLinkHandler>(
          update: (_, AuthService authService, EmailSecureStore storage, __) =>
              FirebaseEmailLinkHandler(
            auth: authService,
            emailStore: storage,
            firebaseDynamicLinks: FirebaseDynamicLinks.instance,
          )..init(),
          dispose: (_, linkHandler) => linkHandler.dispose(),
        ),
      ],
      child: AuthWidgetBuilder(
          builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
        return MaterialApp(
          theme: ThemeData(primarySwatch: Colors.indigo),
          home: EmailLinkErrorPresenter.create(
            context,
            child: AuthWidget(userSnapshot: userSnapshot),
          ),
        );
      }),
    );
  }
}
