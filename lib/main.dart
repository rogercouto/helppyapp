import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:helppyapp/blocs/animation_bloc.dart';
import 'package:helppyapp/blocs/app_bloc.dart';
import 'package:helppyapp/blocs/posts_bloc.dart';
import 'package:helppyapp/models/feel.dart';
import 'package:helppyapp/models/info.dart';
import 'package:helppyapp/screens/about_screen.dart';
import 'package:helppyapp/screens/breath_screen.dart';
import 'package:helppyapp/screens/help_screen.dart';
import 'package:helppyapp/screens/home_screen.dart';
import 'package:helppyapp/screens/goal_screen.dart';
import 'package:helppyapp/screens/feels_screen.dart';
import 'package:helppyapp/screens/motivation_screen.dart';
import 'package:helppyapp/screens/splash_screen.dart';
import 'package:helppyapp/widgets/bottom_bar.dart';
import 'package:helppyapp/widgets/screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stack/stack.dart' as data;
import 'helpers/content_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async{

  await PermissionHandler().requestPermissions([PermissionGroup.storage]);

  return runApp(
    BlocProvider(
      blocs: [
          Bloc((i) => AnimationBloc()),
          Bloc((i) => AppBloc()),
          Bloc((i) => PostsBloc())
        ],
        child: MaterialApp(
          home: Loader(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.brown,
            primaryColor: Color.fromARGB(255, 56, 33, 13),
            secondaryHeaderColor: Color.fromARGB(255, 255, 214, 0),
            backgroundColor: Color.fromRGBO(245, 245, 245, 1.0)
          ),
        )
    )
  );
}

class Loader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Map<int, Info> _infos;
    Map<int, Feel> _feels;

    ContentHelper.getInfoMap().then((infoMap){
      _infos = infoMap;
      ContentHelper.getFeelsMap().then((feelsMap){
        _feels = feelsMap;
        Future.delayed(Duration(seconds: 2)).then((_){
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) {
              return MainApp(_infos, _feels);
            })
          );
        });
      });
    });
    return SplashScreen();
  }

}

class MainApp extends StatefulWidget {
  
  final Map<int, Info> infos;
  final Map<int, Feel> feels;
  
  MainApp(this.infos, this.feels);
  
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  final pageController = PageController();

  final bloc = BlocProvider.getBloc<AppBloc>();

  var _stack = data.Stack<int>();

  final FirebaseMessaging _messaging = FirebaseMessaging();

  void handleMsg(Map<String, dynamic> msg){
    if (msg.containsKey("data")){
      final dynamic data = msg["data"];
      if (data["click_action"] == "FLUTTER_NOTIFICATION_CLICK"){
        _stack.pop();
        _stack.push(5);
        pageController.jumpToPage(5);      
      }
    }
  }

  @override
  void initState(){
    super.initState();
    /*
    _messaging.getToken().then((token){
      print(token);
    });
    */
    _messaging.configure(
      onMessage: (Map<String, dynamic> msg) async {
        handleMsg(msg);
      },
      onLaunch: (Map<String, dynamic> msg) async {
        handleMsg(msg);
      },
      onResume: (Map<String, dynamic> msg) async {
        handleMsg(msg);
      },
    );
  }

  Widget _aboutButton(BuildContext context){
    return IconButton(icon: Icon(Icons.help), onPressed: (){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return AboutScreen(widget.infos[4].text);
        })
      );
    });
  }

  List<Screen> getScreens(){
    var postsBloc = BlocProvider.getBloc<PostsBloc>();
    return[
      Screen(0,"Home", Icons.home, HomeScreen(pageController),
        action: _aboutButton(context)
      ),
      Screen(1, "Objetivo", Icons.check, GoalScreen(widget.infos[1].text),),
      Screen(2, "Ajuda", Icons.phone, HelpScreen()),
      Screen(3, widget.infos[2].title, Icons.library_books, FeelsScreen(widget.infos[2], widget.feels)),
      Screen(4, "Exercício", Icons.directions_run, BreathScreen(widget.infos[3])),
      Screen(5, "Motivação", Icons.sentiment_very_satisfied, MotivationScreen(),
        action: IconButton(icon: Icon(Icons.refresh), onPressed: (){
          postsBloc.getPosts();
        },)
      )
    ];
  }

  Future<bool> _question(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Fechar o app?'),
        //content: new Text('Tem certeza que deseja fechar o app?'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Não'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Sim'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    _stack.push(0);
    List<Screen> screens = getScreens();
    ThemeData themeData = Theme.of(context);
    return WillPopScope(
      onWillPop: (){
        if (_stack.top() == pageController.page.round()){
          _stack.pop();//discard actual one
        }
        if (_stack.isNotEmpty){
          int old = _stack.pop();
          pageController.jumpToPage(old);
          return Future.value(false);
        }else{
          return _question(context);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          backgroundColor: themeData.secondaryHeaderColor,
          centerTitle: true,
          title: StreamBuilder(
            stream: bloc.outTitle,
            initialData: "Home",
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Text("${snapshot.data}", style: TextStyle(color: themeData.primaryColor),);
            },
          ),
          iconTheme: IconThemeData(color: themeData.primaryColor),
          actions: <Widget>[
            StreamBuilder(
              stream: bloc.outAction,
              initialData: _aboutButton(context),
              builder: (context, snapshot){
                return snapshot.data != null ? snapshot.data : Container();
              },
            )
          ],
        ),
        body: PageView(
          //physics: NeverScrollableScrollPhysics(),
          children: screens.map((screen)=>screen.child).toList(),
          controller: pageController,
          onPageChanged: (index){
            _stack.push(index);
            bloc.changeTitle(screens[index].screenTitle);
            bloc.changePageIndex(index);
            if (screens[index].action != null){
              bloc.changeAction(screens[index].action);
            }else{
              bloc.changeAction(Container());
            }
          },
        ),
        bottomNavigationBar: StreamBuilder(
          initialData: 0,
          stream: bloc.outIndex,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return BottomBar(snapshot.data, pageController, screens);
          },
        ),
        
      ),
    );
  }
}