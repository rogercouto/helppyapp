import 'package:cloud_firestore/cloud_firestore.dart';

class Feel{

  int id;
  String title;
  String subtitle;
  String descr;

  Feel(this.id, this.title, this.subtitle, this.descr);

  Feel.fromDocument(DocumentSnapshot document){
    id = document["id"];
    title = document["title"];
    subtitle = document["subtitle"];
    descr = document["descr"];
  }

  @override
  String toString() {
    return "{id: $id, title: $title, subtitle: $subtitle, descr: $descr}";
  }

}