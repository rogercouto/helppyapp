import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helppyapp/models/post.dart';
import 'package:rxdart/rxdart.dart';

const PAGE_SIZE = 3;

class PostsBloc implements BlocBase{

  Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> _docs = [];
  DocumentSnapshot _lastDoc;

  bool _loading = true;
  bool _morePostsAvaliable = true;
  bool _gettingMorePosts = false;
  
  final _controller = new BehaviorSubject<List<Post>>();
  
  Stream get outPosts => _controller.stream;

  bool get morePostsAvaliable => _morePostsAvaliable;

  bool get isLoading => _loading;

  /*
   * Get posts / Refresh 
   */
  getPosts() async{
    _loading = true;
    _morePostsAvaliable = true;
    _controller.sink.add([]);
    Query q = _firestore.collection("blog").orderBy("id", descending: true).limit(PAGE_SIZE);
    QuerySnapshot querySnapshot = await q.getDocuments();
    if(querySnapshot.documents.length < PAGE_SIZE){
      _morePostsAvaliable = false;
    }
    if (querySnapshot.documents.length > 0){
      _lastDoc = querySnapshot.documents[querySnapshot.documents.length -1];
      _docs = querySnapshot.documents;
    }
    _controller.sink.add(Post.fromDocuments(_docs));
    _loading = false;
  }

  bool emptyBlog(){
    return _docs.length == 0;
  }

  /*
   * Get mext page of posts 
   */
  getMorePosts() async{
    if (_morePostsAvaliable && !_gettingMorePosts){
      _gettingMorePosts = true;
      Query q = _firestore
      .collection("blog")
      .orderBy("id", descending: true)
      .startAfter([_lastDoc.data["id"]])
      .limit(PAGE_SIZE);
      QuerySnapshot querySnapshot = await q.getDocuments();
      if(querySnapshot.documents.length < PAGE_SIZE){
        _morePostsAvaliable = false;
      }
      if (querySnapshot.documents.length > 0){
        _lastDoc = querySnapshot.documents[querySnapshot.documents.length - 1];
        _docs.addAll(querySnapshot.documents);
      }
      _controller.sink.add(Post.fromDocuments(_docs));
      _gettingMorePosts = false;
    }
  }

  //Listeners

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _controller.close();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => null;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }

}