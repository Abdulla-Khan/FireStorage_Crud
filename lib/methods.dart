// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    User user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user!;
    if (user != null) {
      print('Account Created Sucessfully');

      user.updateDisplayName(name);
      await firestore.collection('users').doc(_auth.currentUser?.uid).set({
        'name': name,
        'email': email,
        // 'status': 'Unavailable',
        'uid': _auth.currentUser!.uid,
        'password': password
      });

      return user;
    } else {
      print('Account Creation Failed');
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> logIn(String email, password) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    User user = (await auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user!;
    if (user != null) {
      print('Login Sucessfull');
      return user;
    } else {
      print('Account Creation Failed');
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  try {
    await auth.signOut();
  } catch (e) {
    print(e);
  }
}
