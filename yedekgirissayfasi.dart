import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persentilizlem/childList.dart';
import 'package:persentilizlem/core/services/backup/createnewuser.dart';
import 'package:persentilizlem/core/services/backup/loginSocialMedia.dart';
import 'package:persentilizlem/core/services/backup/loginwithmail.dart';
import 'package:persentilizlem/core/services/backup/resetpass.dart';
import 'package:persentilizlem/core/services/backup/takeBackupifyoulogin.dart';
import 'package:persentilizlem/util/widgets/myappbars.dart';
import 'forLogin.dart';
import 'package:flip_card/flip_card.dart';

class FireBaseBackUpSystem extends StatefulWidget {
  const FireBaseBackUpSystem({Key? key}) : super(key: key);

  @override
  State<FireBaseBackUpSystem> createState() => _FireBaseBackUpSystemState();
}

class _FireBaseBackUpSystemState extends State<FireBaseBackUpSystem> {
  FirebaseAuth? auth;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  bool islogin = false;
  TextEditingController _email = TextEditingController();
  TextEditingController _pasword = TextEditingController();
  StreamSubscription? _sub;

  @override
  void initState() {
    auth = FirebaseAuth.instance;
    auth?.authStateChanges().listen((User? user) {
      if (user == null) {
        islogin = false;
        setState(() {});
      } else {
        islogin = true;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _pasword.dispose();
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ResetPassword()));
        },
      ),
      resizeToAvoidBottomInset: true,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MyAppBars(
        ctx: context,
        goBack: TextButton.icon(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChildList(isOnline: true)));
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          label: Icon(
            Icons.home,
            color: Colors.black87,
          ),
        ),
        roat: [
          islogin == true
              ? IconButton(
                  onPressed: () {
                    FirebaseAuthLogin.logOut();
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ))
              : SizedBox(),
        ],
      ),
      body: _fullscreen(),
    );
  }

//////arka plan ayarlanması için ve login container için
  Widget _fullscreen() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
      decoration: BoxDecoration(color: Colors.white),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: _loginLayout(),
    );
  }

  /////////////

  ///////layout ayarladık
  Widget _loginLayout() {
    return Container(
      child: islogin == false ? _forLoginColumn(context) : TakeBackUpYouLogin(),
    );
  }

  //////// login yapılacak ada
  Widget _forLoginColumn(BuildContext context) {
    return FlipCard(
        key: cardKey,
        direction: FlipDirection.VERTICAL,
        flipOnTouch: false,
        front: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(9)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: const Center(
                      child: Text(
                    "GİRİŞ YAPIN",
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w600),
                  )),
                ),
                LoginWithMail(
                  flipkey: cardKey,
                ),
                const LoginWithSocialMedia(),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Verilerinizi kaybetmemeniz için kayıt veya  giriş yapmanız gerekmektedir.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        back: CreateNewUserWithMail(
            email: _email, password: _pasword, flipkey: cardKey));
  }
}
