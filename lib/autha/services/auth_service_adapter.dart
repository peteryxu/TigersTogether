import 'dart:async';

import 'package:apple_sign_in/apple_sign_in.dart';
import '../services/auth_service.dart';
import '../services/firebase_auth_service.dart';
import '../services/mock_auth_service.dart';
import 'package:flutter/foundation.dart';
import '../../models.dart';


enum AuthServiceType { firebase, mock }

class AuthServiceAdapter implements AuthService {
  AuthServiceAdapter({@required AuthServiceType initialAuthServiceType})
      : authServiceTypeNotifier =
            ValueNotifier<AuthServiceType>(initialAuthServiceType) {
    _setup();
  }
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final MockAuthService _mockAuthService = MockAuthService();

  // Value notifier used to switch between [FirebaseAuthService] and [MockAuthService]
  final ValueNotifier<AuthServiceType> authServiceTypeNotifier;
  AuthServiceType get authServiceType => authServiceTypeNotifier.value;
  AuthService get authService => authServiceType == AuthServiceType.firebase
      ? _firebaseAuthService
      : _mockAuthService;

  StreamSubscription<AppUser> _firebaseAuthSubscription;
  StreamSubscription<AppUser> _mockAuthSubscription;

  void _setup() {
    // Observable<User>.merge was considered here, but we need more fine grained control to ensure
    // that only events from the currently active service are processed
    _firebaseAuthSubscription =
        _firebaseAuthService.onAuthStateChanged.listen((user) {
      if (authServiceType == AuthServiceType.firebase) {
        _onAuthStateChangedController.add(user);
      }
    }, onError: (dynamic error) {
      if (authServiceType == AuthServiceType.firebase) {
        _onAuthStateChangedController.addError(error);
      }
    });
    _mockAuthSubscription =
        _mockAuthService.onAuthStateChanged.listen((user) {
      if (authServiceType == AuthServiceType.mock) {
        _onAuthStateChangedController.add(user);
      }
    }, onError: (dynamic error) {
      if (authServiceType == AuthServiceType.mock) {
        _onAuthStateChangedController.addError(error);
      }
    });
  }

  @override
  void dispose() {
    _firebaseAuthSubscription?.cancel();
    _mockAuthSubscription?.cancel();
    _onAuthStateChangedController?.close();
    _mockAuthService.dispose();
    authServiceTypeNotifier.dispose();
  }

  final StreamController<AppUser> _onAuthStateChangedController =
      StreamController<AppUser>.broadcast();
  @override
  Stream<AppUser> get onAuthStateChanged => _onAuthStateChangedController.stream;

  @override
  Future<AppUser> currentUser() => authService.currentUser();

  @override
  Future<AppUser> signInAnonymously() => authService.signInAnonymously();

  @override
  Future<AppUser> createUserWithEmailAndPassword(String email, String password) =>
      authService.createUserWithEmailAndPassword(email, password);

  @override
  Future<AppUser> signInWithEmailAndPassword(String email, String password) =>
      authService.signInWithEmailAndPassword(email, password);

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      authService.sendPasswordResetEmail(email);

  @override
  Future<AppUser> signInWithEmailAndLink({String email, String link}) =>
      authService.signInWithEmailAndLink(email: email, link: link);

  @override
  Future<bool> isSignInWithEmailLink(String link) =>
      authService.isSignInWithEmailLink(link);

  @override
  Future<void> sendSignInWithEmailLink({
    @required String email,
    @required String url,
    @required bool handleCodeInApp,
    @required String iOSBundleID,
    @required String androidPackageName,
    @required bool androidInstallIfNotAvailable,
    @required String androidMinimumVersion,
  }) =>
      authService.sendSignInWithEmailLink(
        email: email,
        url: url,
        handleCodeInApp: handleCodeInApp,
        iOSBundleID: iOSBundleID,
        androidPackageName: androidPackageName,
        androidInstallIfNotAvailable: androidInstallIfNotAvailable,
        androidMinimumVersion: androidMinimumVersion,
      );

  @override
  Future<AppUser> signInWithFacebook() => authService.signInWithFacebook();

  @override
  Future<AppUser> signInWithGoogle() => authService.signInWithGoogle();

  @override
  Future<AppUser> signInWithApple({List<Scope> scopes}) =>
      authService.signInWithApple();

  @override
  Future<void> signOut() => authService.signOut();
}
