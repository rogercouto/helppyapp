import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helppyapp/blocs/animation_bloc.dart';
import 'package:helppyapp/blocs/bar_bloc.dart';
import 'package:helppyapp/blocs/posts_bloc.dart';
import 'package:helppyapp/models/feel.dart';
import 'package:helppyapp/models/info.dart';
import 'package:helppyapp/screens/breath_screen.dart';
import 'package:helppyapp/screens/help_screen.dart';
import 'package:helppyapp/screens/home_screen.dart';
import 'package:helppyapp/screens/goal_screen.dart';
import 'package:helppyapp/screens/feels_screen.dart';
import 'package:helppyapp/screens/motivation_screen.dart';
import 'package:helppyapp/screens/splash_screen.dart';
import 'package:helppyapp/widgets/screen.dart';
import 'package:helppyapp/widgets/screen_builder.dart';

//const CYELLOW = Color.fromARGB(255, 255, 214, 0);
//const CBROWN = Color.fromARGB(255, 56, 33, 13);

void main() => runApp(

  BlocProvider(
    blocs: [
        Bloc((i) => BarBloc()),
        Bloc((i) => AnimationBloc()),
        Bloc((i) => PostsBloc())
      ],
      child: MaterialApp(
        home: Splash(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.brown,
          primaryColor: Color.fromARGB(255, 56, 33, 13),
          secondaryHeaderColor: Color.fromARGB(255, 255, 214, 0)
        ),
      )
  )
);

class MainApp extends StatelessWidget {
    
  final Map<int, Info> _infoMap;  //info collection
  final Map<int, Feel> _feelsMap;
  final String user;

  MainApp(this._infoMap, this._feelsMap, this.user);

  static Widget backToHome(PageController pageController){
    var barBloc = BlocProvider.getBloc<BarBloc>();
    return IconButton(icon: Icon(Icons.home), onPressed: (){
      pageController.jumpToPage(0);
      barBloc.changeTitle("Home");
      barBloc.changeAction(Container());
    });
  }

  @override
  Widget build(BuildContext context) {
    //Prevents landscape orientation mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    ScreenBuilder builder = ScreenBuilder(Theme.of(context));
    
    builder.add(Screen("Home", Icons.home, HomeScreen(builder.pageController)));

    builder.add(Screen("Objetivo", Icons.check, GoalScreen(_infoMap[1].text), 
      action: backToHome(builder.pageController)));

    builder.add(Screen("Ajuda", Icons.phone, HelpScreen(),
      action: backToHome(builder.pageController)));

    builder.add(Screen(_infoMap[2].title, Icons.help, FeelsScreen(_infoMap[2], _feelsMap)));

    builder.add(Screen("Exercício", Icons.directions_run, BreathScreen(_infoMap[3])));
    
    var postsBloc = BlocProvider.getBloc<PostsBloc>();
    builder.add(Screen("Motivação", Icons.library_books, MotivationScreen(), 
      action: IconButton(icon: Icon(Icons.refresh), onPressed: (){
        postsBloc.getPosts();
      },)));
    
    builder.add(Screen("Sobre", Icons.help, 
      Container(child: Padding(
        padding: EdgeInsets.all(50),
        child: Text("Em construção..."),
      )),
      action: backToHome(builder.pageController)
      ),
    );

    return builder.build();
  }
}