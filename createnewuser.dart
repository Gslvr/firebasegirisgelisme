import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'forLogin.dart';

class CreateNewUserWithMail extends StatefulWidget {
   CreateNewUserWithMail({Key? key, required this.email, required this.password, required this.flipkey}) : super(key: key);
  TextEditingController email;
  TextEditingController password;
   GlobalKey<FlipCardState> flipkey;
  @override
  State<CreateNewUserWithMail> createState() => _CreateNewUserWithMailState();
}

class _CreateNewUserWithMailState extends State<CreateNewUserWithMail> {

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(builder: (context, child) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(9)),
        child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Giriş Yapın",
                  style: TextStyle(fontSize: 24.sp),
                  textScaleFactor: 0.8,
                ),
                SizedBox(
                  height: 10.sp,
                ),
                SizedBox(
                  height: 35.sp,
                  child: TextFormField(
                    controller: widget.email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: "Mail Adres",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(9)))),
                  ),
                ),
                SizedBox(
                  height: 20.sp,
                ),
                SizedBox(
                  height: 35.spMax,
                  child: TextFormField(
                    controller: widget.password,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Şifre",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(9)))),
                  ),
                ),
                SizedBox(
                  height: 10.sp,
                ),
                Container(
                  width: double.infinity,
                  height: 30.sp,
                  child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuthLogin.createnewAccountWithMail(
                            email: widget.email.text.trim(), password: widget.password.text.trim());
                      },
                      child: Text(
                        "Kayıt Olun",
                        style: TextStyle(fontSize: 20.spMax),
                        textScaleFactor: 0.9,
                      )),
                ),
                TextButton(
                    onPressed: () {
                      widget.flipkey.currentState!.toggleCard();
                    },
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Hesabınız var mı?",
                          style: TextStyle(color: Colors.black, fontSize: 12.spMax),
                        ),
                        TextSpan(
                            text: " Giriş yapın?",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.spMax)),
                      ]),
                    ))
              ],
            )),
      );
    });
  }
}
