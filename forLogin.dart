import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:persentilizlem/core/services/backup/repoForFire.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthLogin {
   FirebaseAuthLogin();
  static FirebaseAuth? auth = FirebaseAuth.instance;

  static Future<String> authwithMail({required String mail, required String sifre})async {
    String islemsonucu;
    try{
    await auth!.signInWithEmailAndPassword(email: mail.trim(), password: sifre.trim());
    islemsonucu = "Giriş tamamlandı";
    }
    on FirebaseException catch(e){

      if (e.code == 'user-not-found') {
       islemsonucu ='Kayıtlı değilsiniz. Üye olun!.';
      } else if (e.code == 'wrong-password') {
       islemsonucu ='Hatalı şifre.';
      }
      else islemsonucu = "Bilinmeyen bir hata oluştu";

    }
    return islemsonucu;
  }

 static Future<String> authwithGoogle() async {
    String islemtamam;
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

      islemtamam = 'islem tamamlandi';
    } on FirebaseAuthException catch (e) {
      print(e.code);
      islemtamam = 'Bir sorun oluştu';
    }
    return islemtamam;
  }
 static Future<String> authwithApple() async {
    String islemtamam;

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
      islemtamam = 'İşlem tamam';
    } on FirebaseAuthException catch (e) {
      print(e.code);
      islemtamam = 'Bir hata oluştu';
    }
    return islemtamam;
  }
 static void createnewAccountWithMail({required String email, required String password})async{
    await auth!.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());
  }
 static Future<void> isLogin() async{
    auth!.authStateChanges().listen((event) {
      print(event);
    });
 }
 static void logOut() async {
    auth?.signOut();
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
    auth!.sendPasswordResetEmail(email: email.trim(),actionCodeSettings: actionCodeSettings);

  }
 static void forgetMe()async{
   auth!.currentUser!.delete();
 }
 static void deleteMeandMyData()async{
   FirebaseYedekAlVer.deleteMyData();
    //forgetMe();
 }
}