import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart' as ss;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
  
class SaveShare {

  static String _getFileExtension(String url){
    var s = url.split(".");
    if (s.length > 0)
      return s[s.length -1];
    return null; 
  }

  static String _getMimeType(String ext){
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
  /*
   * Create image as bytes from RepaintBoundary 
   */
  static Future<Uint8List> createImageBytes(GlobalKey key) async{
    RenderRepaintBoundary rpb = key.currentContext.findRenderObject();
    ui.Image image = await rpb.toImage();
    ByteData bData = await image.toByteData(format: ui.ImageByteFormat.png);
    return bData.buffer.asUint8List();
  }

  /*
   *  Get Image as bytes from url
   */
  static Future<Uint8List> getImageBytes(String url) async{
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    return await consolidateHttpClientResponseBytes(response);
  }

  /*
   *  Save image in gallery
   */
  static Future<bool> saveImageBytes(Uint8List imageBytes) async{
    final result = await ImageGallerySaver.saveImage(imageBytes);
    return (result != null);
  }

  /*
   * Share image from bytes 
   */
  static Future<void> shareImageFromBytes(Uint8List imageBytes) async{
    await Share.file("Compartilhar via:", "post.png", imageBytes, "image/png");
  }

  /*
   * Share image from url
   */
  static Future<void> shareImageFromUrl(String url) async{
    String ext = _getFileExtension(url);
    String type = _getMimeType(ext);
    Uint8List bytes = await getImageBytes(url);
    int time = new DateTime.now().millisecondsSinceEpoch;
    await Share.file("Compartilhar via:", "$time.$ext", bytes, type);
  }

  /*
   * Share link 
   */
  static Future<void> shareLink(String url) async{
    ss.Share.share(url);
  }

  /*
   * Share Youtube video from url 
   */
  static Future<void> shareVideo(String videoId) async{
    ss.Share.share("https://www.youtube.com/watch?v=$videoId");
  }
  
  /*
   * Ask for write permission im gallery 
   */
  static Future<bool> askStoragePermission(BuildContext context) async{
    PermissionStatus status = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
    if (status == PermissionStatus.denied){
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("É necessário conceder permissão para o aplicativo salvar arquivos!",),
          action: SnackBarAction(
            label: "Abrir configurações",
            onPressed: () async{
              await PermissionHandler().openAppSettings();
            },
          ),
        )
      );
      return false;
    }
    return true;
  }
  
}