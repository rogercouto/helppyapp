import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helppyapp/models/feel.dart';
import 'package:helppyapp/models/info.dart';

/*
 * Classe responsável por retornar as informações do firebase
 */
class ContentHelper {

    static Future<Map<int, Info>> getInfoMap() async{
      QuerySnapshot infoSnapshot = await Firestore.instance.collection("info").getDocuments();
      Map<int, Info> infoMap = Map();
      infoSnapshot.documents.forEach((document){
        Info info = Info.fromDocument(document);
        infoMap[info.id] = info;
      });
      return infoMap;
    }

    static Future<Map<int, Feel>> getFeelsMap() async{
      Map<int, Feel> feelsMap = Map();
      QuerySnapshot feelsSnapshot = await Firestore.instance.collection("feels").getDocuments();
      feelsSnapshot.documents.forEach((document){
        Feel feel = Feel.fromDocument(document);
        feelsMap[feel.id] = feel;
      });
      return feelsMap;
    }

}