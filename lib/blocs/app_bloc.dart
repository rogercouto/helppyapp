import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc implements BlocBase{

  final _titleController = BehaviorSubject<String>();

  final _actionsController = BehaviorSubject<Widget>();

  final _indexController = BehaviorSubject<int>(); 

  Stream get outTitle => _titleController.stream;

  Stream get outAction => _actionsController.stream;

  Stream get outIndex => _indexController.stream;

  void changeTitle(String newTitle){
    if (newTitle != null){
      _titleController.sink.add(newTitle);
    }else{
      _titleController.sink.add("Helppy");
    }
  }

  void changeAction(Widget action){
    _actionsController.sink.add(action);
  }

  void changePageIndex(int pageIndex){
    _indexController.sink.add(pageIndex);
  }

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _titleController.close();
    _actionsController.close();
    _indexController.close();
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