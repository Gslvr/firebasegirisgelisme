import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'forLogin.dart';

class LoginWithMail extends StatefulWidget {
  LoginWithMail({Key? key, required this.flipkey}) : super(key: key);
  GlobalKey<FlipCardState> flipkey;

  @override
  State<LoginWithMail> createState() => _LoginWithMailState();
}

class _LoginWithMailState extends State<LoginWithMail> {
  TextEditingController _email = TextEditingController();
  TextEditingController _pasword = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Geçerli Mail adresi giriniz';
                  } else
                    null;
                },
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                    EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                    icon: Icon(Icons.mail_lock),
                    labelText: "e-Posta",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        borderSide: BorderSide(color: Colors.green)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red, style: BorderStyle.solid),
                        gapPadding: 30,
                        borderRadius: BorderRadius.circular(5)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red, style: BorderStyle.solid),
                        gapPadding: 30,
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 60,
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Geçerli bir şifre giriniz';
                  } else
                    null;
                },
                controller: _pasword,
                obscureText: true,
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                    EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                    icon: Icon(Icons.password),
                    labelText: "Şifre",
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        borderSide: BorderSide(color: Colors.green)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red, style: BorderStyle.solid),
                        gapPadding: 30,
                        borderRadius: BorderRadius.circular(5)),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.red, style: BorderStyle.solid),
                        gapPadding: 30,
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      String sonuc =await  FirebaseAuthLogin.authwithMail(
                          mail: _email.text.trim(),
                          sifre: _pasword.text.trim());
                      setState(() {});
                      Color sonucrenk = sonuc == "Giriş tamamlandı"?Colors.green:Colors.red;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(sonuc,textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),backgroundColor: sonucrenk,));
                    }
                  },
                  child: Text("Giriş Yapın")),
            ),
            TextButton(
                onPressed: () {
                  if (_email.text != '') {
                    FirebaseAuthLogin.forgetPassword(_email.text.trim());
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "E-posta adresinizi gönderilen link ile yeni şifre alabilirsiniz!",
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.black87,
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Geçerli bir mail adresi giriniz",
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.red,
                    ));
                  }
                },
                child: Text("Şifremi Unuttum!")),
            TextButton(
                onPressed: () {
                  widget.flipkey.currentState!.toggleCard();
                },
                child: Text("Hesabınız Yoksa Kayıt Olun!")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Divider(
                      color: Colors.black,
                      height: 5,
                    )),
                SizedBox(
                  width: 25,
                ),
                Text(
                  "veya",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 25,
                ),
                Expanded(
                    child: Divider(
                      color: Colors.black,
                      height: 5,
                    )),
              ],
            ),
          ],
        )));
  }


}
