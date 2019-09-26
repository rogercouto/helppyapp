import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:helppyapp/blocs/posts_bloc.dart';
import 'package:helppyapp/widgets/post_card.dart';

class MotivationScreen extends StatelessWidget {

  final bloc = BlocProvider.getBloc<PostsBloc>();

  final _sc = ScrollController();

  @override
  Widget build(BuildContext context) {

    bloc.getPosts();

    _sc.addListener((){
      double max = _sc.position.maxScrollExtent;
      double curr = _sc.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      if (max - curr <= delta){
        bloc.getMorePosts();
      }
    });

    return StreamBuilder(
      initialData: [],
      stream: bloc.outPosts,
      builder: (context, snapshot){
        if (snapshot.hasData && !bloc.isLoading){
          return ListView.builder(
            controller: _sc,
            itemCount: snapshot.data.length + 1,
            itemBuilder: (context, index) {
              if (index < snapshot.data.length){
                GlobalKey key = new GlobalKey(); 
                return PostCard(key, snapshot.data[index]);
              }else{
                if (bloc.morePostsAvaliable){
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),  
                    child: CircularProgressIndicator(),         
                  );
                }else{
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child:Text(bloc.emptyBlog() ? "Nenhuma postagem ainda" : "Fim das postagens")
                  );
                }
              }
            },
          );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}