import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:persentilizlem/core/services/backup/repoForFire.dart';

class TakeBackUpYouLogin extends StatefulWidget {
  const TakeBackUpYouLogin({Key? key}) : super(key: key);

  @override
  State<TakeBackUpYouLogin> createState() => _TakeBackUpYouLoginState();
}

class _TakeBackUpYouLoginState extends State<TakeBackUpYouLogin> {
  FirebaseAuth? auth;
  bool islogin = true;
  DateTime? backUpDate;
  var dataString;

  @override
  void initState() {
    auth = FirebaseAuth.instance;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      backUpDate = await FirebaseYedekAlVer.showCurrentTime();

      dataString = backUpDate != '' && backUpDate != null
          ? DateFormat.yMMMd().format(backUpDate!)
          : 'Henüz kayıt yok';

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Container(
          height: 100,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: "Hesap:",
                      style:
                          GoogleFonts.adventPro(fontSize: 22, color: Colors.grey),
                    ),
                    TextSpan(
                      text: "${auth?.currentUser?.email.toString()}",
                      style: GoogleFonts.adventPro(
                          fontSize: 22, color: Colors.red.shade300),
                    ),
                  ]),
                  textAlign: TextAlign.center,
                ),
                backUpDate != null
                    ? RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "Son Yedek:",
                            style: GoogleFonts.adventPro(
                                fontSize: 22, color: Colors.grey),
                          ),
                          TextSpan(
                            text: dataString,
                            style: GoogleFonts.acme(
                                fontSize: 22, color: Colors.red.shade300),
                          ),
                        ]),
                        textAlign: TextAlign.center,
                      )
                    : SizedBox(),
              ],
            ),
          )),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(9)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  FirebaseYedekAlVer.addDataOncetime().then((value) {
                    value != true ? _showsnackbar(text: 'Yedekleme tamamlandı', iserror: false):_showsnackbar(text: 'Bir sorun oluştu', iserror: true);
                  });
                },
                child: Container(
                  width: _size.width * 0.6,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          child: Lottie.network(
                              "https://assets9.lottiefiles.com/packages/lf20_78Ybeg.json",
                              repeat: false,
                              options: LottieOptions(enableMergePaths: true)),
                          height: _size.height * 0.15,
                        ),
                        Text(
                          "Verilerimi Yedekle",
                          style: GoogleFonts.abel(
                              color: Colors.grey, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                 backUpDate !=null?_verisilonayi():_showsnackbar(text: 'Henüz yedeğiniz yok!', iserror: true);
                },
                child: Container(
                  width: _size.width * 0.6,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          child: Lottie.network(
                              "https://assets10.lottiefiles.com/packages/lf20_Rmw6MbWro1.json",
                              repeat: false,
                              options: LottieOptions(enableMergePaths: true)),
                          height: _size.height * 0.15,
                        ),
                        Text(
                          "Verilerimi Geri Yükle",
                          style: GoogleFonts.abel(
                              color: Colors.grey, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async{
                  if (backUpDate != null) {
                    bool? sonuc = await FirebaseYedekAlVer.deleteMyData();
                    if (sonuc == true) {
                      _showsnackbar(
                          text: 'Bulut verileriniz silindi', iserror: false);
                    } else {
                      _showsnackbar(
                          text: 'Bulut verileriniz silindi', iserror: false);
                    }
                  } else {
                    _showsnackbar(text: 'Bulut yedeğiz yok!!', iserror: true);
                  }
                },
                child: Container(
                  width: _size.width * 0.6,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          child: Lottie.network(
                              "https://assets3.lottiefiles.com/packages/lf20_utFspQ.json",
                              repeat: false,
                              options: LottieOptions(enableMergePaths: true)),
                          height: _size.height * 0.15,
                        ),
                        Text(
                          "Tüm Verilerimi Sil",
                          style: GoogleFonts.abel(
                              color: Colors.grey, fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _showsnackbar ({required String text, required bool iserror}){
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text,textAlign: TextAlign.center),backgroundColor: iserror == false?Colors.black87:Colors.red,));
  }

  /// deleting Data
  _verisilonayi() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning_amber_outlined,
                  color: Colors.redAccent,
                  size: 40,
                ),
                SizedBox(
                  width: 10,
                ),
                Text("DİKKAT!"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Mevcut verilerinizin üzerine yazılsın mı?",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "Kabul ederseniz şu anda cihazınızdaki veriler kaldırılacak ve yedeklediğiniz veriler yüklenecek. \n 'İptal' seçeneği işaretlerseniz buluttaki veriler cihazınızdaki veriler korunarak yüklenecek. Bu durumda tekrarlı kayıtlar olabilir.",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                           FirebaseYedekAlVer.readData();
                          _showsnackbar(text: "Mevcut kayıtlar korundu", iserror: false);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Vazgeç",
                          style: TextStyle(color: Colors.green, fontSize: 24),
                        )),
                    TextButton(
                        onPressed: () async{
                          await databaseHelper.tumhastalarisil();
                          FirebaseYedekAlVer.readData();
                          _showsnackbar(text: 'Mevcut kayıtların üzerine yazıldı!', iserror: false);
                          Navigator.pop(context);
                        },
                        child: const Text("Onayla",
                            style: TextStyle(color: Colors.red, fontSize: 24))),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
