import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart' as autha;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements autha.AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  autha.User _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return autha.User(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }

  @override
  Stream<autha.User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebase);
  }

  @override
  Future<autha.User> signInAnonymously() async {
    final UserCredential authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<autha.User> signInWithEmailAndPassword(
      String email, String password) async {
    final UserCredential authResult = await _firebaseAuth
        .signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<autha.User> createUserWithEmailAndPassword(
      String email, String password) async {
    final UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<autha.User> signInWithEmailAndLink({String email, String link}) async {
    final UserCredential authResult =
        await _firebaseAuth.signInWithEmailLink(email: email, emailLink: link);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<bool> isSignInWithEmailLink(String link) async {
    return await _firebaseAuth.isSignInWithEmailLink(link);
  }

  @override
  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleID,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
  }) async {
    return await _firebaseAuth.sendSignInLinkToEmail(
        email: email, actionCodeSettings: null);

    /*
    (
      email: email,
      url: url,
      handleCodeInApp: handleCodeInApp,
      iOSBundleID: iOSBundleID,
      androidPackageName: androidPackageName,
      androidInstallIfNotAvailable: androidInstallIfNotAvailable,
      androidMinimumVersion: androidMinimumVersion,
    );
    */
  }

  @override
  Future<autha.User> signInWithGoogle_old() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final UserCredential authResult = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
            code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
            message: 'Missing Google Auth Token');
      }
    } else {
      throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  Future<autha.User> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential =
          await _firebaseAuth.signInWithCredential(googleAuthCredential);
      final user = userCredential.user;
      final userEmail = user.email;
      print(userEmail);
      print(user.displayName);
      print(user.photoURL);

      if (!userEmail.contains('chccs.k12.nc.us')) {
        print("need to sign out");
        await signOut();
        throw new Exception(
            'Need to log in with school email: chccs.k12.nc.us');
      } else {
        return _userFromFirebase(userCredential.user);
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<autha.User> signInWithFacebook() async {
    return null;
  }

  @override
  Future<autha.User> signInWithApple({List<Scope> scopes = const []}) async {
    return null;
  }

  @override
  Future<autha.User> currentUser() async {
    final User user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    //final FacebookLogin facebookLogin = FacebookLogin();
    //await facebookLogin.logOut();
    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {}
}
