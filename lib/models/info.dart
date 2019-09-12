import 'package:cloud_firestore/cloud_firestore.dart';

class Info {

  int id;
  String title;
  String text;

  Info(this.id, this.title, this.text);

  Info.fromDocument(DocumentSnapshot document){
    id = document["id"];
    title = document["title"];
    text = document["text"];
  }

  @override
  String toString() {
    return "{id: $id, title: $title, text: $text}";
  }

}