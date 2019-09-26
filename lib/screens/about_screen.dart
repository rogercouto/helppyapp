import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {

  final String description;

  AboutScreen(this.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text("Sobre", style: TextStyle(color: Theme.of(context).primaryColor)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Icon(Icons.help, color: Colors.black54,),
              Text("Sobre o app", style: TextStyle(color: Colors.black54),)
            ],),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Text(description,
                textAlign: TextAlign.justify,
              ),
            ),
            SizedBox(height: 40),
            Row(children: <Widget>[
              Icon(Icons.info, color: Colors.black54,),
              Text("Versão 1.0.0", style: TextStyle(color: Colors.black54),)
            ],),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Text("Desenvolvido por Adriano Almeida e Roger Couto",
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                child: Text("https://www.pipelinelab.com.br",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.blueAccent),
                  textDirection: TextDirection.ltr,
                ),
                onPressed: (){
                  launch("https://www.pipelinelab.com.br");
                },
              ),
            )
            //https://www.pipelinelab.com.br

          ],
        ),
      ),
    );
  }
}