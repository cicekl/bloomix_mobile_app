import 'package:bloomix_mobile_app/models/app_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _firebase = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  User? get currentUser {
    return _firebase.currentUser;
  }

  Future<UserCredential> registerUser({
    required String email,
    required String fullName,
    required String password,
  }) async {
    try {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredentials.user!;

      await firebaseUser.updateDisplayName(fullName);

      final appUser = AppUser(
        id: firebaseUser.uid,
        fullName: fullName,
        email: email,
      );

      await _firestore
          .collection('users')
          .doc(appUser.id)
          .set(appUser.toJson());

      return userCredentials;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredentials = await _firebase.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredentials;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _firebase.signOut();
  }
}
