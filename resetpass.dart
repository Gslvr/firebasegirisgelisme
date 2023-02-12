import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:persentilizlem/util/widgets/myappbars.dart';

import 'yedekgirissayfasi.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword(this.oobCode);

  String? oobCode;

  @override
  State<StatefulWidget> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth? auth;
  String? oobCode;
  String? isresetPass;
  bool isobsecure = true;
  IconData? issecureIcon = Icons.remove_red_eye_sharp;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  void initState() {
    auth = FirebaseAuth.instance;

    super.initState();
  }

/*  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) async{
    isresetPass = dynamicLinkData.link.queryParameters['mode'];
    oobCode = widget.oobCode??dynamicLinkData.link.queryParameters['oobCode'];
    print(oobCode);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    oobCode = widget.oobCode ?? null;
    return Material(
      child: Scaffold(
        appBar: MyAppBars(
          title:'Şifrenizi Değiştirin', ctx: context,
          goBack: IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>FireBaseBackUpSystem()));
          }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.black87,),),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Center(
              child: Container(
                width: 200,
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LottieBuilder.network("https://assets8.lottiefiles.com/packages/lf20_ed9hgtrb.json",repeat: false),
                        Container(
                          height: 50,
                          child: TextFormField(
                            onSaved: (String? value) async {
                              try {
                                if (value != null &&
                                    value != '' &&
                                    oobCode != null) {
                                  await auth!.confirmPasswordReset(
                                      code: oobCode ?? '', newPassword: value);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          FireBaseBackUpSystem()));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      buildSnackBarMessage(
                                          'Şifreniz boş olamaz'));
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'invalid-action-code') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      buildSnackBarMessage(
                                          'Link süresi dolmuş ya da daha önce kullanılmış. Lütfen sıfırlama işlemini tekrarlayınız.'));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FireBaseBackUpSystem()));
                                } else if (e.code == 'weak-password') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      buildSnackBarMessage(
                                          'Şifreniz kritelere uygun değil. Lütfen tekrar deneyiniz'));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      buildSnackBarMessage(
                                          'Bilinmeyen bir hata oluştu. Lütfen tekrar deneyiniz. Sorununuz devam ederse bize ulaşınız'));
                                }
                              }
                              ;
                            },
                            style: GoogleFonts.acme(
                                color: Colors.black87, fontSize: 24),
                            obscureText: isobsecure,
                            decoration: InputDecoration(
                              labelText: 'Şifre',
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isobsecure = !isobsecure;
                                    issecureIcon = isobsecure != false
                                        ? Icons.security
                                        : Icons.remove_red_eye;
                                  });
                                },
                                icon: Icon(Icons.remove_red_eye),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        ElevatedButton(
                            onPressed: () {
                              _formKey.currentState!.save();
                            },
                            child: Text("Şifre Değiştir",style: GoogleFonts.acme( ),))
                      ],
                    )),
              ),
            );
          },
        ),
      ),
    );
  }

  SnackBar buildSnackBarMessage(String mesaj) {
    return SnackBar(
      content: Center(
        child: Text(
          "$mesaj",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: Colors.deepOrangeAccent,
    );
  }
}
