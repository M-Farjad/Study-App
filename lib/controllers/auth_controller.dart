import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:study_app/firebase_ref/references.dart';
import 'package:study_app/screens/home/home_screen.dart';
import 'package:study_app/screens/login/login_screen.dart';

import '../widgets/dialogs/dialog_widget.dart';

class AuthController extends GetxController {
  @override
  void onReady() {
    initAuth();
    super.onReady();
  }

  late FirebaseAuth _auth;
  final _user =
      Rxn<User>(); //when getx is used put the User(from firebase) to Rxn
  late Stream<User?> _authStateChanges;

  void initAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    _auth = FirebaseAuth.instance; // single tone
    _authStateChanges =
        _auth.authStateChanges(); // to check user changed or not
    _authStateChanges.listen(((User? user) {
      _user.value = user;
    }));

    navigateToIntroduction();
  }

  signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      GoogleSignInAccount? account =
          await _googleSignIn.signIn(); // sign in with google
      if (account != null) {
        final _authAccount =
            await account.authentication; //it will have token id and access id
        final _credential = GoogleAuthProvider.credential(
          //  requesting google for token and access id
          idToken: _authAccount.idToken,
          accessToken: _authAccount.accessToken,
        );
        // now sending token to firebase
        await _auth.signInWithCredential(_credential);
        await saveUser(account);
        NavigateToHomePage();
      }
      //using try catch block as we are going to connect to the server
    } on Exception catch (error) {
      // AppLogger.e(error);
    }
  }

  User? getUser() {
    _user.value = _auth.currentUser;
    return _user.value;
  }

  saveUser(GoogleSignInAccount account) {
    // sign in user to firebase
    userRf.doc(account.email).set({
      //set in firebase takes a map
      "email": account.email,
      "name": account.displayName,
      "profilepic": account.photoUrl,
    });
  }

  Future<void> signOut() async {
    // Applogger.d('Sign Out');
    try {
      await _auth.signOut();
      NavigateToHomePage();
    } on FirebaseAuthException catch (error) {
      // AppLogger.e(error){
    }
  }

  void navigateToIntroduction() {
    Get.offAllNamed(HomeScreen.routeName); //TODO
  }

  NavigateToHomePage() {
    Get.offAllNamed(HomeScreen.routeName);
  }

  void showLoginAlertDialogue() {
    Get.dialog(
      Dialogs.questionStartDialogue(onTap: () {
        Get.back();
        //navigate to login page
        NavigateToLoginPage();
      }),
      barrierDismissible: false,
    );
  }

  void NavigateToLoginPage() {
    Get.toNamed(LoginScreen.routeName);
  }

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }
}
