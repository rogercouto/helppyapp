import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Post{

  int id;
  String title;
  String text;
  DateTime createdAt;
  String media;
  String mediaType;
  String mediaThumb;

  TextAlign textAlign;
  Color textBg;

  Post.fromDocument(DocumentSnapshot document){
    id = document["id"];
    title = document["title"];
    text = document["text"];
    createdAt = document["created_at"].toDate();
    media = document["media"];
    mediaType = document["media_type"];
    mediaThumb = document["media_thumb"];
    switch (document["text_align"]) {
      case "left":
        textAlign = TextAlign.left;
        break;
      case "right":
        textAlign = TextAlign.right;
        break;
      case "center":
        textAlign = TextAlign.center;
        break;
      case "justify":
        textAlign = TextAlign.justify;
        break;      
      default:
        textAlign = TextAlign.center;
        break;
    }
    if (document["text_bg"] != null && document["text_bg"].length == 3){
      textBg = Color.fromARGB(255, document["text_bg"][0], document["text_bg"][1], document["text_bg"][2]);
    }else{
      textBg = Colors.blueGrey;
    }
  } 

  String createdAtString(){
    return DateFormat("dd/MM/yyyy HH:mm").format(createdAt);
  }

}