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
class RepoForFireBackUp{


  Future<List<HastaListeModel>> hastalistesi() async{
    return await databaseHelper.hastaListesi();
  }
  Future<List<AtesTakip>> ateslistesi()async{
    return databaseHelper.atesListesiYedekicin();
  }
  Future<List<HastaVerilerModeli>> olcumlistesi()async{
    return databaseHelper.persentillerYedekicin();
  }
  Future<List<Asi>> asilistesi()async{
    return databaseHelper.asiLarYedekicin();
  }
}

class FirebaseYedekAlVer {
  FirebaseYedekAlVer();
 static String? userUid ({required FirebaseAuth auth}){
   return auth.currentUser?.uid;
 }
 //// user add to firebase
 static void addUser ({required List<HastaListeModel> liste, required FirebaseAuth auth}){
   String? uid = FirebaseYedekAlVer.userUid(auth: auth);
   for (var list in liste){
     _firestore.collection(uid!).doc("Hastaliste").collection("${list.hastaID}").doc('${list.hastaID}').set(
         list.toMap()!
     );
   }
   print("işlem tamamlandı");
 }
 //// fever add to firebase
  static void addFever ({required List<AtesTakip> liste, required FirebaseAuth auth}){
   String? uid = FirebaseYedekAlVer.userUid(auth: auth);
   for (var list in liste){
     _firestore.collection(uid!).doc("Ates").collection("${list.hastaId}").doc('${list.id}').set(
         list.toJson()
     );
   }
   print("işlem tamamlandı");
 }
 /// vaccine add to firebase
  static void addVaccine ({required List<Asi> liste, required FirebaseAuth auth}){
   String? uid = FirebaseYedekAlVer.userUid(auth: auth);
   for (var list in liste){
     _firestore.collection(uid!).doc("Asi").collection("${list.hastaid}").doc('${list.id}').set(
         list.toJson()
     );
   }
   print("işlem tamamlandı");
 }
 /// centiles add to firease
  static void addPers ({required List<HastaVerilerModeli> liste, required FirebaseAuth auth}){
   String? uid = FirebaseYedekAlVer.userUid(auth: auth);
   for (var list in liste){
     _firestore.collection(uid!).doc("Centiles").collection("${list.hastaId}").doc('${list.veriID}').set(
         list.toMap()!
     );
   }
   print("işlem tamamlandı");
 }

 static void deleteMyData()async{
   String? uid;
   List<String> basliklar = ['Asi','Ates','Centiles','Hastaliste'];
   final batch = _firestore.batch();
   uid = FirebaseAuthLogin.auth!.currentUser!.uid;
   if (FirebaseAuthLogin.auth !=null) {
     if (FirebaseAuthLogin.auth!.currentUser !=null)
       basliklar.forEach((element) async{
         print("$element siliniyor");
         var snapshotdata = await _firestore.collection(uid!).doc(element).collection('1').get();
         for (var data in snapshotdata.docs){

          await data.reference.delete();
         }
         print("Silindi");
       });

   
    }
  }
  ////////////////download and re-write backUp

static void readData ()async{
  String uid = FirebaseYedekAlVer.userUid(auth: _auth)!;
  int? sonhastaid = await databaseHelper.sonHastaid()??2;


  //// Aşı için
  //önce verileri sil
  databaseHelper.tumAsilariveritabanisil();
  for (var i = 0;i< sonhastaid;i++) {
      var collection =
          await _firestore.collection('$uid').doc('Asi').collection("$i").get();
      for (var data in collection.docs) {
        Asi _asidata = Asi.fromJson(data.data());
        ////veritabanına ekle
        databaseHelper.asiTekEkle(hastaid: i, asi: _asidata);
      }
    }


  //// ateş için
  /// önce verileri sil tekrar olmasın
  databaseHelper.ateslerisil();
  for (var i = 0;i<= sonhastaid;i++) {
      var collection =
          await _firestore.collection('$uid').doc('Ates').collection("$i").get();
      for (var data in collection.docs) {
        AtesTakip _atesdata = AtesTakip.fromMap(data.data());

        ////veritabanına ekle
        databaseHelper.atesiVerisiEkle(atesTakip: _atesdata).whenComplete(() => print("işlem tamamlandı"));
      }
    }


  /// persentiller
  /// Önce persentilleri sil
  databaseHelper.tumhastaverileriSil();
  for (var i = 0;i<= sonhastaid;i++) {
    var collection =
    await _firestore.collection('$uid').doc('Centiles').collection("$i").get();
    for (var data in collection.docs) {
      HastaVerilerModeli _atesdata = HastaVerilerModeli.fromMap(data.data());

      ////veritabanına ekle
      databaseHelper.hastaveriEkle(_atesdata).whenComplete(() => print("işlem tamamlandı"));
    }
  }
  
  
  /// hastanın verileri
  /// Önce  sil
  databaseHelper.hastatamaminisil();
  for (var i = 0;i<= sonhastaid;i++) {
    var collection =
    await _firestore.collection('$uid').doc('Hastaliste').collection("$i").get();
    for (var data in collection.docs) {
      HastaListeModel _hastadata = HastaListeModel.fromMap(data.data());

      ////veritabanına ekle
      databaseHelper.hastaEkle(_hastadata).whenComplete(() => print("işlem tamamlandı"));
    }
  }
}


}
