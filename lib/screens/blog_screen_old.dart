import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:helppyapp/models/post.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

const API_KEY = "AIzaSyAQ-5abONK2YaBj9mAANdvzvojO86T5Cq0";

class BlogScreenOld extends StatelessWidget {

  final String user;

  BlogScreenOld(this.user);

  Widget createMedia(Post post){
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

  Widget createCard(BuildContext context, Post post){
    return GestureDetector(
      child: Card(
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
                child: post.media != null ? Text("${post.text}\n") : 
                  Container(
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
              SizedBox(
                child: createMedia(post)
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FloatingActionButton(
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    child: Icon(Icons.share, color: Colors.white,), 
                    onPressed: () {

                    },
                  ),
                  Text("Publicado em ${post.createdAtString()}", style: TextStyle(fontSize: 16), textAlign: TextAlign.right,)
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        print("$post");
      },
    );
  }

  ListTile buildTile(){
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = new ScrollController();
    scrollController.addListener((){
      if (scrollController.offset <= scrollController.position.minScrollExtent
      && !scrollController.position.outOfRange){
        print("Reach the top");
      }
      if (scrollController.offset >= scrollController.position.maxScrollExtent
      && !scrollController.position.outOfRange){
        print("Reach the bottom!");
      }
    });
    return StreamBuilder(
      stream: Firestore.instance.collection("blog").orderBy("created_at", descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch(snapshot.connectionState){
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator(),);
          default:
            return ListView.builder(
              controller: scrollController,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                  Post post = Post.fromDocument(snapshot.data.documents[index]);
                  return createCard(context, post);
              }
            );            
        }
      },
    );

  }
}