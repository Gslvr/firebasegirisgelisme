
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persentilizlem/core/services/backup/takeBackupifyoulogin.dart';
class FirebaseForward extends StatefulWidget {
   FirebaseForward({Key? key, required this.data}) : super(key: key);
   final String data;

  @override
  State<FirebaseForward> createState() => _FirebaseForwardState();
}

class _FirebaseForwardState extends State<FirebaseForward> {
  @override
  Widget build(BuildContext context) {
    print("buraya geliyor mu?");
    return  FutureBuilder(
          future: Future.delayed(Duration(milliseconds: 1000)),
          builder: (context,snapshatdata){
            if (snapshatdata.connectionState == ConnectionState.waiting){
              return const Center(child: CupertinoActivityIndicator(),);
            }
            else if (snapshatdata.hasError){
              return  const Center(child: Text("Bir sorun oluştu"));
            }
            else if (snapshatdata.connectionState == ConnectionState.done){
              print(snapshatdata.data);
              return  TakeBackUpYouLogin();
            }
            else {
              return Text("Bilinmeyen bir hata oluştu");
            }
          });
    }
}
