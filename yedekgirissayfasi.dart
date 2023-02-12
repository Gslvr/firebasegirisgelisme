import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persentilizlem/atestakip/Model/atesModel.dart';
import 'package:persentilizlem/childList.dart';
import 'package:persentilizlem/core/services/backup/repoForFire.dart';
import 'package:persentilizlem/model/hastaModel.dart';
import 'package:persentilizlem/util/widgets/myappbars.dart';
import '../../../asilar/Model/asiHelperForCalendar.dart';
import '../../../model/hastaVerileriModel.dart';
import 'forLogin.dart';
import 'package:flip_card/flip_card.dart';
import 'resetpass.dart';


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
        setState(() {
          islogin = false;
        });
      } else {
        setState(() {
          islogin = true;
        });
        print("Oturum açık ${user.displayName} maili ${user.email}");

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
      resizeToAvoidBottomInset: true,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MyAppBars(
        ctx: context,
        goBack: IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChildList(isOnline: true)));
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => ResetPassword(''))),
        child: Icon(Icons.link),
      ),
      body: _fullscreen(),
    );
  }

//////arka plan ayarlanması için ve login container için
  Widget _fullscreen() {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
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
      child: islogin == false ? _forLoginColumn(context) : _forBackUpPage(),
    );
  }

  /////////////

//////google ve apple giriş buttonları
  Widget _loginContainer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildloginButton(context, login: "Google"),
          buildloginButton(context, login: "Apple"),
        ],
      ),
    );
  }

  /////// button
  GestureDetector buildloginButton(BuildContext context,
      {required String login}) {
    String? imgsecim = login == "Google" ? "btn_google.png" : "applelogo.png";
    String? buttonyazi =
        login == "Google" ? "Google ile giriş yapın" : "Apple ile giriş yapın";

    return GestureDetector(
      onTap: () {
        login == "Google"
            ? FirebaseAuthLogin.authwithGoogleSilent()
            : FirebaseAuthLogin.authwithApple();
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

  //////// login yapılacak ada

  Widget _forLoginColumn(BuildContext context) {
    return FlipCard(
        key: cardKey,
        direction: FlipDirection.HORIZONTAL,
        flipOnTouch: false,
        front: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
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
                  child: Center(
                      child: Text(
                    "GİRİŞ YAPIN",
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w600),
                  )),
                ),
                loginwithmail(),
                _loginContainer(),
                SizedBox(
                  height: 20,
                ),
                const Text(
                    "Verilerinizi kaybetmemeniz için kayıt ve ya  giriş yapmanız gerekmektedir.",textAlign: TextAlign.center,),
              ],
            ),
          ),
        ),
        back: _createnewusermail());
  }

  ////mail ile login olmak için
  Widget loginwithmail() {
    return Form(
        child: Column(
      children: [
        SizedBox(
          height: 40,
          child: TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelText: "Mail Adres",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(9)))),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 40,
          child: TextFormField(
            controller: _pasword,
            obscureText: true,
            decoration: InputDecoration(
                labelText: "Şifre",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(9)))),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () {
                FirebaseAuthLogin.authwithMail(
                    mail: _email.text, sifre: _pasword.text);
              },
              child: Text("Giriş Yapın")),
        ),
        TextButton(
            onPressed: () {
              FirebaseAuthLogin.forgetPassword('gsivas@gmail.com');
            },
            child: Text("Şifremi Unuttum!")),
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
        TextButton(
            onPressed: () {
              cardKey.currentState!.toggleCard();
            },
            child: Text("Hesabınız Yoksa Kayıt Olun!"))
      ],
    ));
  }
  ////Yeni kullanıcı oluştur
  Widget _createnewusermail() {
    return ScreenUtilInit(builder: (context, child) {
      return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(9)),
        child: Form(
            child: Column(
          children: [
            Text(
              "Giriş Yapın",
              style: TextStyle(fontSize: 18.sp),
              textScaleFactor: 0.8,
            ),
            SizedBox(
              height: 10.sp,
            ),
            SizedBox(
              height: 35.sp,
              child: TextFormField(
                controller: _email,
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
                controller: _pasword,
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
                        email: _email.text, password: _pasword.text);
                  },
                  child: Text(
                    "Kayıt Olun",
                    style: TextStyle(fontSize: 20.spMax),
                    textScaleFactor: 0.9,
                  )),
            ),
            TextButton(
                onPressed: () {
                  cardKey.currentState!.toggleCard();
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

  //////////

  /////giriş yapıldıysa veriyi  kaydet ya da geri yükle
  Widget _forBackUpPage() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(9)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(
                Icons.auto_stories_sharp,
                color: Colors.red,
              ),
              onPressed: () async {
                List<HastaListeModel> _hastalistesi =
                    await RepoForFireBackUp().hastalistesi();
                List<AtesTakip> _ateslistesi =
                    await RepoForFireBackUp().ateslistesi();
                List<HastaVerilerModeli> _perslistesi =
                    await RepoForFireBackUp().olcumlistesi();
                List<Asi> _vaccinelistesi =
                    await RepoForFireBackUp().asilistesi();
                FirebaseYedekAlVer.addUser(liste: _hastalistesi, auth: auth!);
                FirebaseYedekAlVer.addFever(liste: _ateslistesi, auth: auth!);
                FirebaseYedekAlVer.addVaccine(
                    liste: _vaccinelistesi, auth: auth!);
                FirebaseYedekAlVer.addPers(liste: _perslistesi, auth: auth!);
              },
              label: Text("Verileri Yedekle"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(Colors.black)),
            ),
            ElevatedButton.icon(
              icon: Icon(
                Icons.auto_stories_sharp,
                color: Colors.red,
              ),
              onPressed: () async {
                FirebaseYedekAlVer.readData();
              },
              label: Text("Verileri Oku"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(Colors.black)),
            ),
            ElevatedButton.icon(
              icon: Icon(
                Icons.auto_stories_sharp,
                color: Colors.red,
              ),
              onPressed: () async {
                FirebaseAuthLogin.deleteMeandMyData();
              },
              label: Text("Beni ve Verilerimi Sil"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(Colors.black)),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text("Mail: ${auth?.currentUser?.email.toString()}"),
            ),
          ],
        ),
      ),
    );
  }

///////////////////

}
