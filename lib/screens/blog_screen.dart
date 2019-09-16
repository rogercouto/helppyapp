import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:helppyapp/models/post.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share/share.dart' as ss;
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;

const API_KEY = "AIzaSyAQ-5abONK2YaBj9mAANdvzvojO86T5Cq0";
const PAGE_SIZE = 3;

class BlogScreen extends StatefulWidget {

  final String user;

  BlogScreen(this.user);

  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {

  Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> _posts = [];
  bool _loadingPosts = true;
  DocumentSnapshot _lastDoc;
  ScrollController _sc = ScrollController();
  bool _gettinMorePosts = false;
  bool _morePostsAvaliable = true;

  Map<int, GlobalKey> _keyMap = Map(); //int: post.id

  _getPosts() async{
    Query q = _firestore.collection("blog").orderBy("id", descending: true).limit(PAGE_SIZE);
    setState(() {
      _loadingPosts = true;
    });
    QuerySnapshot querySnapshot = await q.getDocuments();
    if(querySnapshot.documents.length < PAGE_SIZE){
      _morePostsAvaliable = false;
    }
    _lastDoc = querySnapshot.documents[querySnapshot.documents.length -1];
    _posts = querySnapshot.documents;
    setState(() {
      _loadingPosts = false;
    });
  }

  _getMorePosts() async{
    if (!_morePostsAvaliable){
      return;
    }
    _gettinMorePosts = true;
    Query q = _firestore
      .collection("blog")
      .orderBy("id", descending: true)
      .startAfter([_lastDoc.data["id"]])
      .limit(PAGE_SIZE);
    QuerySnapshot querySnapshot = await q.getDocuments();
    print(querySnapshot.documents.length);
    if(querySnapshot.documents.length < PAGE_SIZE){
      _morePostsAvaliable = false;
    }else{
      _lastDoc = querySnapshot.documents[querySnapshot.documents.length - 1];
      _posts.addAll(querySnapshot.documents);
    }
    setState(() {});
    _gettinMorePosts = false;
  }

  Future<Uint8List> _createImage(Post post) async{
    var key = _keyMap[post.id];
    RenderRepaintBoundary rpb = key.currentContext.findRenderObject();
    ui.Image image = await rpb.toImage();
    ByteData bData = await image.toByteData(format: ui.ImageByteFormat.png);
    return bData.buffer.asUint8List();
  }

  /*
  Future<File> _downloadFile(String url, String filename) async {

    String path = "/storage/emulated/0/DCIM/Camera/";

    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    
    //String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$path$filename');
    print(file);
    await file.writeAsBytes(bytes);
    return file;
  }
  */
  

  String _getMediaExtension(Post post){
    if (post.mediaType == "image"){
      var s = post.media.split(".");
      if (s.length > 0)
        return s[s.length -1];
    }
    return null;
  }

  String _getMediaType(String ext){
    switch (ext.toLowerCase()) {
      case "jpg":
      case "jpeg":
        return "image/jpg";  
        break;
      case "png":
        return "image/png";  
        break;
      default:
        return null;
    }
  }

  _sharePost(Post post) async{
    if (post.media == null){
      Uint8List image = await _createImage(post);
      await Share.file("Hello", "post.png", image, "image/png");
    }else if (post.mediaType == "image"){
      String ext = _getMediaExtension(post);
      String type = _getMediaType(ext);
      var request = await HttpClient().getUrl(Uri.parse(post.media));
      var response = await request.close();
      Uint8List bytes = await consolidateHttpClientResponseBytes(response);
      await Share.file("Helppy", "hellpy.$ext", bytes, type);
    }else if (post.mediaType == "link"){
      ss.Share.share(post.media);
    }else if (post.mediaType == "video"){
      //print("https://www.youtube.com/watch?v=${post.media}");
      ss.Share.share("https://www.youtube.com/watch?v=${post.media}");
    }
  }

  _savePost(BuildContext context, Post post) async{
    Uint8List image;
    if (post.mediaType == "image"){
      PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
      if (permission == PermissionStatus.denied){
        await PermissionHandler().openAppSettings();
      }
      var request = await HttpClient().getUrl(Uri.parse(post.media));
      var response = await request.close();
      image = await consolidateHttpClientResponseBytes(response);
      
    }else if (post.mediaType == null){
      image = await _createImage(post);
    }
    if (image != null){
      final result = await ImageGallerySaver.saveImage(image);
      if (result != null){
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Imagem salva na galeria!"),));
      }else{
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Imagem não pode ser salva na galeria!"),));
      }
    }
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

  Widget _createCard(BuildContext context, Post post){
    var postKey = GlobalKey();
    _keyMap[post.id] = postKey;
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
                  RepaintBoundary(
                    key: postKey,
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
                              await _sharePost(post);
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
                                await _savePost(context, post);
                              },
                            ),
                          ),
                        ) 
                      : Container() ,
                    ],
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

  @override
  void initState() {
    super.initState();
    _getPosts();
    _sc.addListener((){
      double max = _sc.position.maxScrollExtent;
      double curr = _sc.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      if (max - curr <= delta){
        if (!_gettinMorePosts)
          _getMorePosts();
      }
    });
  }

  Widget _createListView(BuildContext context){
    return Container(
      color: Colors.grey[300],
      child: _posts.length == 0 ? Center(
        child: Text("Nenhuma postagem ainda"),
      ) : 
      ListView.builder(
        itemCount: _posts.length + 1,
        controller: _sc,
        itemBuilder: (BuildContext context, int index) {
          if (index < _posts.length){
            Post post = Post.fromDocument(_posts[index]);
            return _createCard(context, post);
          }else{
            if (_morePostsAvaliable){
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),  
                child: CircularProgressIndicator(),         
              );
            }else{
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child:Text("Fim das postagens")    
              );
            }
          }
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingPosts){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return _createListView(context);
  }
}