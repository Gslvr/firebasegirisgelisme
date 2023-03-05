import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persentilizlem/core/services/backup/firebaseyonlendirme.dart';

import 'forLogin.dart';

class LoginWithSocialMedia extends StatelessWidget {
  const LoginWithSocialMedia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SocialMediaButton(login: "Google"),
          Platform.isIOS?SocialMediaButton(login: "Apple"):SizedBox(),
        ],
      ),
    );
  }
}


class SocialMediaButton extends StatefulWidget {
   SocialMediaButton({Key? key,required this.login}) : super(key: key);
  String login;
  @override
  State<SocialMediaButton> createState() => _SocialMediaButtonState();
}

class _SocialMediaButtonState extends State<SocialMediaButton> {

  String? imgsecim  ;
  String? buttonyazi ;
  @override
  void initState() {
    imgsecim = widget.login == "Google" ? "btn_google.png" : "applelogo.png";
    buttonyazi = widget.login == "Google" ? "Google ile giriş yapın" : "Apple ile giriş yapın";super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        widget.login == "Google"
            ? FirebaseForward(data:await FirebaseAuthLogin.authwithGoogle())
            : FirebaseForward(data:await FirebaseAuthLogin.authwithApple()) ;
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.05,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              color: Colors.white,
              border: Border.all(
                  width: 1, style: BorderStyle.solid, color: Colors.grey)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 2,
              ),
              Image.asset(
                "Assets/img/$imgsecim",
                scale: 3,
                fit: BoxFit.cover,
              ),
              Text(
                "$buttonyazi",
                style: GoogleFonts.roboto(fontSize: 14),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                width: 5,
              ),
            ],
          )),
    );
  }
}
