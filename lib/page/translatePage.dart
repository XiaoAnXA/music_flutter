import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_flutter/Util/HttpUtil.dart';
import 'package:music_flutter/bean/translate_json_entity.dart';

import '../db/DBManager.dart';

class TranslatePage extends StatefulWidget {
  final String language;

  const TranslatePage({Key key, this.language}) : super(key: key);

  @override
  _TranslatePageState createState() => _TranslatePageState(this.language);
}

class _TranslatePageState extends State<TranslatePage> {
  bool isToEnglish = true;
  String result = "翻译";
  Translate translate = Translate(null,null);
  List<Translate> newTranslates = [];
  final String language;
  _TranslatePageState(this.language);

  @override
  void initState() {
    super.initState();
    isToEnglish = (language == "英文") ? true:false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
          body: Column(
            children: <Widget>[
              Hero(tag: "abcd",
                  child: Card(
                    elevation: 10,
                    margin: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0.0))
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      height: 60,
                      child: TextField(
                        onChanged:onTranslate,
                        decoration: InputDecoration(
                            hintText: "输入文字",
                            hintStyle: TextStyle(
                                fontSize: 18,
                              color: Colors.grey[600]
                            ),
                            border: InputBorder.none
                        ),
                        style: TextStyle(
                            fontSize: 18
                        ),
                        autofocus: true,
                        cursorWidth: 0.5,
                        cursorColor: Colors.grey[600],
                      ),
                    ),
                  )
              ),
              Container(
                height: 60,
                width: double.infinity,
                child:  GestureDetector(
                  child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                      elevation: 18,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(result,
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.lightBlue
                          ),
                        ),
                      )
                  ),
                  onTap: (){
                    Navigator.pop<Translate>(context,translate);
                  },
                )
              ),

              Expanded(
                child:ListView.builder(
                    itemCount: newTranslates.length,
                    itemBuilder: (context,index){
                      return new ListTile(
                        leading: Icon(Icons.history) ,
                        title: Text(newTranslates[index].target),
                        subtitle: Text(newTranslates[index].result),
                      );
                    }
                ) ,
              )
            ],
          )
      ),
    );
  }

  onTranslate(String q) async {
    if(isToEnglish){
      HttpUtil().RequsetTranslate(q, "zh-CHS", "en").then((response){
        TranslateJsonEntity entity = TranslateJsonEntity().fromJson(json.decode(response.toString()));
        if(entity!=null){
          setState(() {
            translate.result = entity?.translation[0];
            translate.target = entity.query;
            result = entity.translation.toString() == null ? "翻译" : entity.translation[0];
            newTranslates.insert(0, Translate(entity.query,entity?.translation[0]));
          });
        }
      }
      );
    }else{
      HttpUtil().RequsetTranslate(q, "en", "zh-CHS").then((response){
        TranslateJsonEntity entity = TranslateJsonEntity().fromJson(json.decode(response.toString()));
        if(entity!=null){
          setState(() {
            translate.result = entity?.translation[0];
            translate.target = entity.query;
            result = entity.translation.toString() == null ? "翻译" : entity.translation[0];
            newTranslates.insert(0, Translate(entity.query,entity?.translation[0]));
          });
        }
      }
      );
    }
  }
}
