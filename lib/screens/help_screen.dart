import 'package:flutter/material.dart';
import 'package:helppyapp/helpers/screen_helper.dart';
import 'package:url_launcher/url_launcher.dart';

//CVV
// chat: http://cvvweb.mysuite1.com.br/client/chatan.php?h=&inf=&lfa="
// phone: 188 launch("tel://188");
// email: https://www.cvv.org.br/e-mail/

class HelpScreen extends StatelessWidget {

  ScreenHelper _screenHelper;

  Widget button(String text, IconData iconData, Color color, String url){
    Size btnSize = _screenHelper.getHelpBtnSize();
    return RaisedButton(
        child: SizedBox(
          height: btnSize.height,
          width: btnSize.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(iconData, color: Colors.white, size: _screenHelper.getHelpBtnIconSize(),),
              Text(text, style: TextStyle(fontSize: _screenHelper.getHelpBtnFontSize(text.length), color: Colors.white),)
            ],
          ), 
        ),
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        color: color,
        onPressed: () {
          launch(url);
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    _screenHelper = ScreenHelper(context);
    return SingleChildScrollView(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: _screenHelper.getTextBoxSize(),
              child: Text("O CVV – Centro de Valorização da Vida realiza apoio emocional e prevenção do suicídio, atendendo voluntária e gratuitamente todas as pessoas que querem e precisam conversar, sob total sigilo por telefone, email e chat 24 horas todos os dias.\n ",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: _screenHelper.getHelpFontSize()),
              ),
            ),
            SizedBox(width: 300,
              child: FlatButton(
                child: Text("https://www.cvv.org.br", 
                    style: TextStyle(fontSize: 18, color: Colors.blue),

                ),
                onPressed: (){
                  launch("https://www.cvv.org.br");
                },
              ),
            ),
            button("188", Icons.phone, Colors.red, "tel://188"),
            SizedBox(height: 20,),
            button("Chat", Icons.chat, Colors.orange, "http://cvvweb.mysuite1.com.br/client/chatan.php?h=&inf=&lfa="),
            SizedBox(height: 20,),
            button("E-mail", Icons.email, Colors.green, "https://www.cvv.org.br/e-mail/")
          ],
        )
      )
    );
  }
}