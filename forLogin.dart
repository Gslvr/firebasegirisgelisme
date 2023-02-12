import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:persentilizlem/core/services/backup/repoForFire.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthLogin {
   FirebaseAuthLogin();
  static FirebaseAuth? auth = FirebaseAuth.instance;
  static void authwithMail({required String mail, required String sifre})async {
    try{
    await auth!.signInWithEmailAndPassword(email: mail, password: sifre);
    }
    catch(e){
    print(e);
    }
  }
 static void authwithGoogleSilent() async {
    try {
      GoogleSignInAccount? _userinGoogle = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? _googleAuth =
      await _userinGoogle?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: _googleAuth?.accessToken,
        idToken: _googleAuth?.idToken,
      );
      await auth
          ?.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
  static void authwithApple() async {
    /// Generates a cryptographically secure random nonce, to be included in a
    /// credential request.
    String generateNonce([int length = 32]) {
      final charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(
          length, (_) => charset[random.nextInt(charset.length)]).join();
    }

    /// Returns the sha256 hash of [input] in hex notation.
    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      final credential = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ], nonce: nonce);
      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        rawNonce: rawNonce,
      );

      await auth?.signInWithCredential(oauthCredential);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
  static void createnewAccountWithMail({required String email, required String password})async{
    await auth!.createUserWithEmailAndPassword(email: email, password: password);
  }
 static void logOut() async {
    auth?.signOut();
    print(await auth?.currentUser?.uid);
  }
  static void forgetPassword (String email)async {

    var actionCodeSettings = ActionCodeSettings(
      url: 'https://prizlem-1a5b7.web.app/?email=${email}',
      androidPackageName: 'com.pediatrirutinleri.prizlem',
      androidInstallApp: true,
      androidMinimumVersion: '12',
      iOSBundleId: 'com.pediatrirutinleri.prwatch',
      handleCodeInApp: true,
    );
    auth!.sendPasswordResetEmail(email: email,actionCodeSettings: actionCodeSettings);
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

/* auth!.checkActionCode(code);
 auth!.applyActionCode(code);*/
  }
 static void forgetMe()async{

   auth!.currentUser!.delete();
 }
 static void deleteMeandMyData()async{
   FirebaseYedekAlVer.deleteMyData();
    //forgetMe();
 }
}