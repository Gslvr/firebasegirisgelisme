import 'dart:convert';
import 'package:persentilizlem/asilar/Model/asiHelperForCalendar.dart';
import 'package:persentilizlem/atestakip/Model/atesModel.dart';
import 'package:persentilizlem/core/services/database_helper.dart';
import 'package:persentilizlem/model/hastaModel.dart';
import 'package:persentilizlem/model/hastaVerileriModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:hive/hive.dart';

class BackUpVt{
DatabaseHelper _databaseHelper = DatabaseHelper();
Database? _db ;
var lock =  Lock(reentrant: true);
Box? box;


Future<void> takebackup ()async{
  box = await Hive.openBox<List<String>>("yedek");
  List<String>? _hastaListesi=[];
  List<String>? _asiListesi = [];
  List<String>? _atestakip= [];
   List<String>? _hastaverileri =[];
  // List<GirisResim>? _girisresim;

  var _data = await _databaseHelper.hastaListesi();

  //hastalistesi boş değilse yap
  if (_data != null){
 if(_data.isNotEmpty){
   for (var hastadata in _data){
     var tekilveri = jsonEncode(hastadata.toMap());
     _hastaListesi.add(tekilveri);
   }
    box!.put('hastalar',_hastaListesi);
////hastalar bitiş

   var _asidata = await _databaseHelper.asiLarYedekicin();
   for (var asi in _asidata){
     var asijson = jsonEncode(asi.toJson());
     _asiListesi.add(asijson);
   }
    box!.put('asi',_asiListesi);
     ///asi tarihlerini diziye aktar


     ///
 /*  var _atesdata = await _databaseHelper.atesListesiYedekicin();
   for (var ates in _atesdata){
     var atesjson = jsonEncode(ates.toJson());
     _atestakip.add(atesjson);
   }
   box!.put('ates',_atestakip);*/

     ////////
     ///
   var _persentildata = await _databaseHelper.persentillerYedekicin();
   for (var persentil in _persentildata){
     var pers = jsonEncode(persentil.toMap());
     _hastaverileri.add(pers);
   }
   box!.put('persentil',_hastaverileri);

     //// gelişim verilerini diziye aktar

 }
  }
  /// giriş resimlerinde bir değişiklik yaparsak burada düzenleme yapabiliriz
 // _girisresim = await _databaseHelper.girisResimListesi();


}
Future<void> writefromBackUp()async{
 List hastadata =  jsonDecode(box!.get("hastalar").toString());
    for (var hasta in hastadata){
   _databaseHelper.hastaEkle(HastaListeModel.fromMap(hasta));

  }

/*  List atesdata =  jsonDecode(box!.get("ates").toString());
   for (var ates in atesdata){
   _databaseHelper.atesiVerisiEkle(atesTakip: AtesTakip.fromMap(ates));

  }*/
  await _databaseHelper.versionGuncelleAtesTablosuEkle();

  List asidata =  jsonDecode(box!.get("asi").toString());
   for (var asiverisi in asidata){
   _databaseHelper.asiYedektenYukle(asiListesi: Asi.fromJson(asiverisi));

  }

  List persdata =  jsonDecode(box!.get("persentil").toString());
  for (var pers in persdata){
    print(pers);
    _databaseHelper.hastaveriEkle(HastaVerilerModeli.fromMap(pers));
  }
}
Future deletedata()async {
  _db = await _databaseHelper.initializeDatabase();
 // _databaseHelper.ateslerisil();
  _databaseHelper.tumAsilariveritabanisil();
   _db!.delete("hastaTablo");
   _db!.delete("hastaVeriler");

}
Future runAllBackUp()async{

  await lock.synchronized(()async{
   await takebackup();
   print("takedbackup");
   await deletedata();
   print("deleteddata");
  // _databaseHelper.versionGuncelleAtesTablosuEkle();
   print("veritabanını güncelle");
   await writefromBackUp();
   print("writefrombackup");

  });

}



}