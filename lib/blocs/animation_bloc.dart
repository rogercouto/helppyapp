import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';

class AnimationBloc implements BlocBase{

  final _animationController = new BehaviorSubject<String>();

  Stream get outAnim => _animationController.stream;

  void changeAnimation(String animationName){
    _animationController.sink.add(animationName);
  }

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
    _animationController.close();
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