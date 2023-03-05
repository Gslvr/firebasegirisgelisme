import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:persentilizlem/asilar/Model/asiHelperForCalendar.dart';
import 'package:persentilizlem/atestakip/Model/atesModel.dart';
import 'package:persentilizlem/core/services/database_helper.dart';
import 'package:persentilizlem/model/hastaModel.dart';
import 'package:persentilizlem/model/hastaVerileriModel.dart';

import 'forLogin.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;
DatabaseHelper databaseHelper = DatabaseHelper();

class RepoForFireBackUp {
  Future<List<HastaListeModel>> hastalistesi() async {
    return await databaseHelper.hastaListesi();
  }

  Future<List<AtesTakip>> ateslistesi() async {
    return databaseHelper.atesListesiYedekicin();
  }

  Future<List<HastaVerilerModeli>> olcumlistesi() async {
    return databaseHelper.persentillerYedekicin();
  }

  Future<List<Asi>> asilistesi() async {
    return databaseHelper.asiLarYedekicin();
  }
}

class FirebaseYedekAlVer {
  FirebaseYedekAlVer();

  static String? userUid({required FirebaseAuth auth}) {
    return auth.currentUser?.uid;
  }

   /////tüm listeyi alıp verileri json çevirip tek seferde kayıt ve tek seferde yükleme yapmayı deneyeceğiz.okuma yazma sayısını azaltmak için
  static Future<bool> addDataOncetime() async {
    bool islemtamam = false;
    DatabaseHelper _databasehelper = DatabaseHelper();
    Map<String, dynamic> veriler;
    //// hasta listesini ayarla
    List<HastaListeModel> _hastalistesi =
        await RepoForFireBackUp().hastalistesi();
    List<Map<String, dynamic>> hastamapList = [];
    for (var hasta in _hastalistesi) {
      hasta != null ? hastamapList.add(hasta.toMap()!) : null;
    }
//////////////
    ///////ateş takipleri

    List<AtesTakip> _ateslistesi = await RepoForFireBackUp().ateslistesi();
    List<Map<String, dynamic>> atesmapList = [];
    for (var data in _ateslistesi) {
      data != null ? atesmapList.add(data.toJson()) : null;
    }
    ///////////
    /////ölçüm listesi
    List<HastaVerilerModeli> _perslistesi =
        await RepoForFireBackUp().olcumlistesi();
    List<Map<String, dynamic>> olcumlistesi = [];
    for (var data in _perslistesi) {
      data != null ? olcumlistesi.add(data.toMap()!) : null;
    }
    ///////

    /////aşı listesi
    List<Asi> _vaccinelistesi = await RepoForFireBackUp().asilistesi();
    List<Map<String, dynamic>> asilistesi = [];
    for (var data in _vaccinelistesi) {
      data != null ? asilistesi.add(data.toJson()) : null;
    }
    //////
    veriler = {
      'hastalistesi': hastamapList,
      'takiplistesi': olcumlistesi,
      'atestakipleri': atesmapList,
      'asilistesi': asilistesi
    };
    var jsondata = jsonEncode(veriler);
    try {
      var uid = _auth.currentUser!.uid;
      if (uid != null) {
        _firestore.collection(uid).doc("hastadata").set({
          'data': jsondata,
          'eklemezamani': DateTime.now().millisecondsSinceEpoch
        }).whenComplete(() {
          islemtamam = true;
          print("işlem tamam");
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      islemtamam = false;
    }
    return islemtamam;
  }

  static Future<DateTime?>? showCurrentTime() async {
    String? uid = FirebaseYedekAlVer.userUid(auth: _auth);
    DateTime? resulttime;
    try {
      var time = await _firestore.collection(uid!).doc('hastadata').get();
      if (time.data() != null) {
        int? result = time['eklemezamani'] ?? null;
        resulttime =
            result != null ? DateTime.fromMillisecondsSinceEpoch(result) : null;
      }
    } on FirebaseException catch (e) {
      print(e.code);
    }
    return resulttime;
  }

  static Future<bool?> deleteMyData() async {
    String? uid;
    late bool islemok;
    islemok = false;
    uid = FirebaseAuthLogin.auth!.currentUser!.uid;
    try{
      if (FirebaseAuthLogin.auth != null) {
        if (FirebaseAuthLogin.auth!.currentUser != null) {
          await _firestore.collection(uid).doc('hastadata').delete();
          islemok = true;
        } else {
          islemok = false;
        }
      } else {
        islemok = false;
      }
    }
   on FirebaseException catch(e){
    islemok = false;
    }


    return  islemok;
  }

  ////////////////download and re-write backUp

  static void readData() async {
    String uid = FirebaseYedekAlVer.userUid(auth: _auth)!;

    var collection = await _firestore.collection('$uid').doc('hastadata').get();
    if (collection != null) {
      var collectiondata = collection.data();
      var veri = collectiondata != null ? collectiondata['data'] : null;
      if (veri != null) {
        var jsondata = jsonDecode(veri);

    for (var data in jsondata['hastalistesi']) {
          databaseHelper.hastaEkle(HastaListeModel.fromMap(data));
        }

        for (var data in jsondata['asilistesi']) {
          databaseHelper.asiYedektenYukle(asiListesi: Asi.fromJson(data));
        }

        for (var data in jsondata['atestakipleri']) {
          databaseHelper.atesiVerisiEkle(atesTakip: AtesTakip.fromMap(data));
        }
        for (var data in jsondata['takiplistesi']) {
          databaseHelper.hastaveriEkle(HastaVerilerModeli.fromMap(data));
        }
      }

    }

  }
}
