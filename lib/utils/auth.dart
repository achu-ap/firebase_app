import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:core';

import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _authService = FirebaseAuth.instance;
  final GoogleSignIn _googleSignin = GoogleSignIn();

  Stream<User?> get userStatus {
    return _authService.authStateChanges().map((e) => e!);
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignin.signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );
      final user = await _authService.signInWithCredential(cred);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signinwithGithub() async {
    try {
      GithubAuthProvider githubAuthProvider = GithubAuthProvider();
      final user = _authService.signInWithProvider(githubAuthProvider);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInAnonymus() async {
    try {
      UserCredential res = await _authService.signInAnonymously();
      User? user = res.user;
      return user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPass(
      {required String email, required String password}) async {
    try {
      UserCredential res = await _authService.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = res.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPass(
      {required String email, required String password}) async {
    try {
      UserCredential res = await _authService.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = res.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      if (_googleSignin.currentUser != null) {
        await _authService.signOut();
      }
      await _googleSignin.disconnect();
      await _authService.signOut();
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
