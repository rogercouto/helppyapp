import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Post{

  String title;
  String text;
  DateTime createdAt;
  String media;
  String mediaType;
  String mediaThumb;

  Post({@required this.title, @required this.text, this.media, this.mediaType, this.mediaThumb}){
    createdAt = DateTime.now();
  }

  Post.fromDocument(DocumentSnapshot document){
    title = document["title"];
    text = document["text"];
    createdAt = document["created_at"].toDate();
    media = document["media"];
    mediaType = document["media_type"];
    mediaThumb = document["media_thumb"];
  } 

  String createdAtString(){
    return DateFormat("dd/MM/yyyy HH:mm").format(createdAt);
  }

}