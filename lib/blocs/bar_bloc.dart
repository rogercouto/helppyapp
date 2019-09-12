import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class BarBloc implements BlocBase{

  final _titleController = BehaviorSubject<String>();

  Stream get outTitle => _titleController.stream;

  void changeTitle(String newTitle){
    if (newTitle != null){
      _titleController.sink.add(newTitle);
    }else{
      _titleController.sink.add("Helppy");
    }
  }

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _titleController.close();
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