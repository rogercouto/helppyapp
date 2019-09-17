import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:helppyapp/helpers/saveshare_helper.dart';
import 'package:helppyapp/models/post.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

const API_KEY = "AIzaSyAQ-5abONK2YaBj9mAANdvzvojO86T5Cq0";

class PostCard extends StatelessWidget {

  final GlobalKey globalKey;
  final Post post;

  PostCard(this.globalKey, this.post);

  Future<void> _sharePost() async{
    switch (post.mediaType) {
      case "image":
        SaveShare.shareImageFromUrl(post.media);
        break;
      case "video":
        SaveShare.shareVideo(post.media);
        break;
      case "link":
        SaveShare.shareLink(post.media);
        break;    
      default:
        Uint8List bytes = await SaveShare.createImageBytes(globalKey);
        SaveShare.shareImageFromBytes(bytes);
    }
  }

  Future<String> _savePost() async{
    Uint8List bytes;
    if (post.mediaType == "image"){
      bytes = await SaveShare.getImageBytes(post.media);
    }else{
      bytes = await SaveShare.createImageBytes(globalKey);
    }
    if (bytes != null){
      bool saved = await SaveShare.saveImageBytes(bytes);
      if (saved)
        return "Imagem salva na galeria!";
    }
    return "Ocorreu um erro ao salvar a imagem!";
  }

  Widget _createMedia(Post post){
    switch (post.mediaType){
      case "image":
        return Stack(
          children: <Widget>[
            Center(child: Column(children: <Widget>[
              SizedBox(height: 30,),
              CircularProgressIndicator(),
              SizedBox(height: 30,)
            ],)),
            Center(child: FadeInImage.memoryNetwork(image: post.media, placeholder: kTransparentImage))
          ],
        );
        break;
      case "video":
        return Stack(
          children: <Widget>[
            Center(child: Column(children: <Widget>[
              SizedBox(height: 30,),
              CircularProgressIndicator(),
              SizedBox(height: 30,)
            ],)),
            Center(child: FadeInImage.memoryNetwork(image: post.mediaThumb, placeholder: kTransparentImage)),
            Center(child: 
              Column(
                children: <Widget>[
                  SizedBox(height: 100,),
                  GestureDetector(
                    child: Icon(Icons.play_arrow, color: Colors.white, size: 64,),
                    onTap: (){
                      FlutterYoutube.playYoutubeVideoById(videoId: post.media, apiKey: API_KEY);
                    },
                  )
                ]
              )
            )
          ],
        );
        break;
      case "link":
        return Container(
          height: 50, 
          width: double.infinity,
          child: FlatButton(
            child: Row(
              children: <Widget>[
                Icon(Icons.link, color: Colors.blue,),
                Text("Abrir link no navegador...", style: TextStyle(color: Colors.blue),)
              ],
            ),
            onPressed: (){
              launch(post.media);
            },
          ),
        );
        break;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: Text(post.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: double.infinity,
                height: post.media != null ? null : post.text.length > 100 ? 300 : 200,
                child: post.media != null ? 
                  (post.text.length > 0 ? Text("${post.text}\n") : Container())
                : 
                  RepaintBoundary(
                    key: globalKey,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      color:  post.textBg,
                      child: Center(
                        child: Text(post.text, 
                          textAlign: post.textAlign,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18, 
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.italic
                          )
                        ),
                      ),
                    ),
                  ),
              ),
              SizedBox(
                child: _createMedia(post)
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        height: 40,
                        width: 40,
                        child: FittedBox(
                          child: FloatingActionButton( 
                            heroTag: "share:{$post.id}", 
                            backgroundColor: Theme.of(context).secondaryHeaderColor,
                            child: Icon(Icons.share, color: Colors.white,), 
                            onPressed: () async{
                              await _sharePost();
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      post.mediaType ==  "image" || post.mediaType == null ? 
                        Container(
                          height: 40,
                          width: 40,
                          child: FittedBox(
                            child: FloatingActionButton(
                              heroTag: "save:{$post.id}",   
                              backgroundColor: Theme.of(context).secondaryHeaderColor,
                              child: Icon(Icons.save, color: Colors.white,), 
                              onPressed: () async{
                                bool canSave = await SaveShare.askStoragePermission(context);
                                if (canSave){
                                  String result = await _savePost();
                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(result),));  
                                }
                              },
                            ),
                          ),
                        ) 
                      : Container() ,
                    ],
                  ),
                  Text("Publicado em \n${post.createdAtString()}", 
                    style: TextStyle(fontSize: 16), 
                    textAlign: TextAlign.right,)
                ],
              ),
            ],
          ),
        ),
      );    
  }

}