import 'dart:async';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:meta/meta.dart';
import '../../models.dart';

abstract class AuthService {
  Future<AppUser> currentUser();
  Future<AppUser> signInAnonymously();
  Future<AppUser> signInWithEmailAndPassword(String email, String password);
  Future<AppUser> createUserWithEmailAndPassword(String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<AppUser> signInWithEmailAndLink({String email, String link});
  Future<bool> isSignInWithEmailLink(String link);
  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleID,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
  });
  Future<AppUser> signInWithGoogle();
  Future<AppUser> signInWithFacebook();
  Future<AppUser> signInWithApple({List<Scope> scopes});
  Future<void> signOut();
  Stream<AppUser> get onAuthStateChanged;
  void dispose();
}
