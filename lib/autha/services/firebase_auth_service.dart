import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final fireStore = FirebaseFirestore.instance;
  
//final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  AppUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return AppUser(
      id: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  @override
  Stream<AppUser> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<AppUser> signInAnonymously() async {
    final UserCredential authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<AppUser> signInWithEmailAndPassword(
      String email, String password) async {
    final UserCredential authResult =
        await _firebaseAuth.signInWithCredential(EmailAuthProvider.credential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<AppUser> createUserWithEmailAndPassword(
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
  Future<AppUser> signInWithEmailAndLink({String email, String link}) async {
    final UserCredential authResult =
        await _firebaseAuth.signInWithEmailLink(email: email, emailLink: link);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<bool> isSignInWithEmailLink(String link) async {
    return _firebaseAuth.isSignInWithEmailLink(link);
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

  Future<AppUser> signInWithGoogleOld() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final UserCredential authResult = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
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

  Future<AppUser> signInWithGoogle() async {
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

      final fbAuthUser = userCredential.user;

      final id = fbAuthUser.uid;
      final email = fbAuthUser.email;
      //final displayName = fbAuthUser.displayName;
      //final photoURL = fbAuthUser.photoURL;

      print("######FirebaseAuth: Google SignIn Data: uid: " + id);
      print("######FirebaseAuth: Google SignIn Data: email: " + email);
      //print("######FirebaseAuth: Google SignIn Data: displayName: " + displayName);
      //print("######FirebaseAuth: Google SignIn Data: photoURL: " + photoURL);

      // retrict LOG IN to only school district
      if (!email.contains('chccs.k12.nc.us')) {
        print("##### This email is NOT part of chapel hill school district");
        //await signOut();
        //throw new Exception('Need to log in with school email: chccs.k12.nc.us');
      } else {
        //try to create User Profile in the firestore
        print("##### This email is  part of chapel hill school district");
      }

      //final user = await tryCreateUserRecordInFirestore(fbAuthUser);
      // return user;
      final usersRef = fireStore.collection('insta_users');

      DocumentSnapshot userDocSnapshot = await usersRef.doc(fbAuthUser.uid).get();
      
      print("##### Got userDocSnapshot");

      // no user record exists, time to create
      if (!userDocSnapshot.exists) {
        print("###### Firestore: creating new user  profile");

        final id = fbAuthUser.uid;
        final email = fbAuthUser.email;
        final displayName = fbAuthUser.displayName;
        final photoURL = fbAuthUser.photoURL;

        await usersRef.doc(id).set({
          "id": id,
          "username": "",
          "photoUrl": "",
          "email": email,
          "displayName": "",
          "bio": "",
          "followers": {},
          "following": {},
        });

        userDocSnapshot = await usersRef.doc(id).get();
        print("######Firestore: created new user  profile");
      }

      final userProfile = AppUser.fromDocument(userDocSnapshot.data());

      print("######Firestore: retrieved user profile " + userProfile.id);

      return userProfile;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  
  @override
  Future<AppUser> signInWithFacebook() async {
    return null;
  }

  @override
  Future<AppUser> signInWithApple({List<Scope> scopes = const []}) async {
    return null;
  }

  @override
  Future<AppUser> currentUser() async {
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
