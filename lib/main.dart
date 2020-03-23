import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_flutter/page/translatePage.dart';
import 'db/DBManager.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
        debugShowCheckedModeBanner: false,
      );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  bool isToEnglish = true;
  bool isTranslated = false;
  String Result = "";
  String Target = "";
  TextEditingController controller = TextEditingController();
  List<Translate> translates = [];
  List<Translate> favoriteTranslates = [];
  TranslateProvider provider;//数据提供者

  AnimationController animationController;
  Animation animation;

  AnimationController leftTextAnimationController;
  Animation<AlignmentGeometry> leftTextAnimation;
  AnimationController rightTextAnimationController;
  Animation<AlignmentGeometry> rightTextAnimation;

  String leftText = "中文";
  String rightText = "英文";
  String temp = "";

  int selectIndex = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAnimation();
    provider = TranslateProvider();
    init();
    queryFavoriteTranslate();
  }
  initAnimation(){
    //旋转动画
    animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    animationController.addStatusListener((status){
      if(status == AnimationStatus.completed){
        animationController.reset();
      }
    });
    animation = Tween(begin: 0.0,end: 0.5).animate(animationController);
    //左边对齐动画
    leftTextAnimationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    leftTextAnimationController.addStatusListener((status){
      if(status == AnimationStatus.completed){
        setState(() {

        });
        leftTextAnimationController.reset();
      }
    });
    leftTextAnimation = Tween<Alignment>(begin: Alignment.centerLeft,end:Alignment.centerRight).animate(leftTextAnimationController);
    //右边对齐动画
    rightTextAnimationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    rightTextAnimationController.addStatusListener((status){
      if(status == AnimationStatus.completed){
        setState(() {

        });
        rightTextAnimationController.reset();
      }
    });
    rightTextAnimation = Tween<Alignment>(begin: Alignment.centerRight,end:Alignment.centerLeft).animate(rightTextAnimationController);
  }

  void init()async{
    await provider.initDatabase().then((value){
      if(value){
        provider.getAllTranslate().then((value){
          setState(() {
            translates = value;
            for(Translate translate in translates){
              if(translate.isCollect){
                favoriteTranslates.add(translate);
              }
            }
          });
        }).catchError( (error){
          print(error);
        });
      }else{
        print("数据库初始化失败");
      }
    });
  }


  queryFavoriteTranslate()async{
//    await provider.initDatabase().then((value){
//      if(value){
//        provider.getFavoriteTranslate().then((value){
//          setState(() {
//            favoriteTranslates = value;
//          });
//        }).catchError( (error){
//          print(error);
//        });
//      }else{
//        print("数据库初始化失败");
//      }
//    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: selectBody(),
      drawer: mainDrawer(),
    );
  }

  Widget homePage(){
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text("Flutter Translate"),
          pinned: false,
        ),
        SliverToBoxAdapter(
          child:
          Column(
            children: <Widget>[
              Card(
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0.0))),
                  elevation: 15,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(right: 10),
                              child: AlignTransition(
                                alignment: leftTextAnimation,
                                child: Text(leftText,
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue[500]
                                  ),
                                ),
                              ),
                            ),
                          ),
                          RotationTransition(
                              alignment: Alignment.center,
                              turns: animation,
                              child: IconButton(
                                icon: Icon(Icons.swap_horiz,color: Colors.blue[500],),
                                onPressed: () {
                                  temp = rightText;
                                  rightText = leftText;
                                  leftText = temp;
                                  animationController.forward();
                                  leftTextAnimationController.forward();
                                  rightTextAnimationController.forward();
                                },
                              )
                          ),
                          Expanded(
                              flex: 2,
                              child:Container(
                                padding: EdgeInsets.only(right: 10),
                                child:  AlignTransition(
                                  alignment: rightTextAnimation,
                                  child: Text(rightText,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue[500]
                                    ),
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                      Hero(tag: "abcd",
                          child: Card(
                            elevation: 0,
                            margin: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(0.0))
                            ),
                            child: Container(
                              padding: EdgeInsets.only(left: 10,right: 10),
                              height: 60,
                              child: TextField(
                                controller: controller,
                                decoration: InputDecoration(
                                    hintText: "点击即可输入文本",
                                    hintStyle: TextStyle(
                                        fontSize: 18
                                    ),
                                    border: InputBorder.none
                                ),
                                style: TextStyle(
                                    fontSize: 18
                                ),
                                onTap: (){
                                  Navigator.of(context).push<Translate>(MaterialPageRoute(builder: (_) {
                                    return TranslatePage(language: rightText);
                                  })).then((translate){
                                    if(translate?.target == null){
                                      return;
                                    }else{
                                      setState(() {
                                        controller.text = translate?.target;
                                        Result = translate?.result;
                                        isTranslated = true;
                                        translates.add(translate);
                                      });
                                      provider.insert(translate);
                                    }
                                  });
                                },
                                readOnly: true,
                                autofocus: true,
                                cursorWidth: 1,
                                cursorColor: Colors.grey,
                              ),
                            ),
                          )
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.camera_alt,color: Colors.indigoAccent),
                                      onPressed: () {},
                                    ),
                                    Text("相机"),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.create,color: Colors.indigoAccent),
                                      onPressed: () {},
                                    ),
                                    Text("手写"),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.record_voice_over,color: Colors.indigoAccent),
                                      onPressed: () {

                                      },
                                    ),
                                    Text("对话"),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.keyboard_voice,color: Colors.indigoAccent,),
                                      onPressed: () {},
                                    ),
                                    Text("语音"),
                                  ],
                                ),
                              ),
                            ]),
                      )
                    ],
                  )
              ),
              translated(),
            ],
          ),
        ),
        SliverFixedExtentList(
          itemExtent: 70.0,
          delegate: SliverChildBuilderDelegate(
            getBuilder,
            childCount: translates?.length,
          ),
        ),
      ],
    );
  }

  Widget favoritePage(){
    return  Column(
        children: <Widget>[
          AppBar(
            title: Text("翻译收藏夹"),
            backgroundColor: Colors.blue,
            leading: IconButton(
              icon: Icon(Icons.arrow_back,color: Colors.white,),
              onPressed: (){
                setState(() {
                  checked[0] = false;
                  checked[1] = false;
                  checked[2] = false;
                  checked[3] = false;
                  checked[0] = true;
                  selectIndex = 0;
                });
              },
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search,color: Colors.white,),
                onPressed: (){

                },
              ),
              IconButton(
                icon: Icon(Icons.sort,color: Colors.white,),
                onPressed: (){

                },
              ),
              IconButton(
                icon: Icon(Icons.refresh,color: Colors.white,),
                onPressed: (){

                },
              ),
            ],
          ),
          Expanded(
            child:ListView.builder(
              itemBuilder: (context,index){
                final favoriteTranslate = favoriteTranslates[index];
                return ListItem(
                  key:Key("${favoriteTranslate.id}"),
                  onTop: (){
                    setState(() {
                      print(index);
                      favoriteTranslates.removeAt(index);
                    });
                  },
                  translate: favoriteTranslate,
                );
              },
              itemCount: favoriteTranslates.length,
            ),
          )
        ],
      );
  }

  Widget offlineTranslationPage(){
    return Center(
      child: Text("离线翻译"),
    );
  }

  Widget settingPage(){
    return Center(
      child: Text("设置"),
    );
  }

  Widget selectBody(){
    switch(selectIndex){
      case 0:
        return homePage();
        break;
      case 1:
        return favoritePage();
        break;
      case 2:
        return offlineTranslationPage();
        break;
      case 3:
        return settingPage();
        break;
      default:
        return homePage();
        break;
    }
  }


  Widget getBuilder(BuildContext context, int index) {
    final item = translates[index].id;
    return Dismissible(
        key: Key("key_$item"),//此处的item要与translates有关：item = index就会报错
        child: ListItem(
          translate: translates[index],
          onTop: () {
            setState(() {
              if(translates[index].isCollect){
                favoriteTranslates.add(translates[index]);
              }else{
                favoriteTranslates.remove(translates[index]);
              }
            });
          },
        ),
        onDismissed: (direction) {
          TranslateProvider provider = TranslateProvider();
          provider.delete(translates[index].id);
          String data = translates[index].target;
          Scaffold.of(context).showSnackBar(
              new SnackBar(content: new Text("$data已删除")));
          setState(() {
            if(translates[index].isCollect){
              favoriteTranslates.remove(translates[index]);
            }
            translates.removeAt(index);
          });
        }
    );
  }

  Widget translated(){
    if(isTranslated){
      return Card(
        color: Colors.indigo,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.star_border),
                      onPressed: (){

                      },
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    Result,
                    style: TextStyle(
                        fontSize: 25
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.content_copy),
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: Result));
                        Fluttertoast.showToast(//添加依赖库时，需要重新安装APP的试验机，不然会出现不存在加载的库
                            msg: "翻译已复制",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      },
                    ),
                  ),
                ),
                PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  onSelected: (value){
                    print(value);
                  },
                  itemBuilder: (context)=>[
                    PopupMenuItem(
                      value:'分享',
                      child: Text('分享'),
                    ),
                    PopupMenuItem(
                      value:'全屏',
                      child: Text('全屏'),
                    ),
                    PopupMenuItem(
                      value:'开始对话',
                      child: Text('开始对话'),
                    ),
                    PopupMenuItem(
                      value:'反向翻译',
                      child: Text('反向翻译'),
                    ),
                  ]
                )
              ],
            )
          ],
        ),
      );
    }else{
      return  Card(
        margin: EdgeInsets.all(10),
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0.0))
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 100,
                width: 100,
                child: IconButton(
                  icon: Icon(Icons.camera),
                  onPressed: (){
                    Navigator.of(this.context).push(MaterialPageRoute(builder: (_) {
                      return TranslatePage();
                    }));
                  },
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child:Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "现已推出新的离线翻译文件。请查看并更新您之前下载的语言",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.black45
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10,bottom: 5,top: 5),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "查看并更新",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.lightBlue
                        ),
                      ),
                    ),
                  ),
                ],
              ) ,
            )
          ],
        ),
      );
    }
  }

  List<IconData> icons = [Icons.home,Icons.book,Icons.beenhere,Icons.settings];
  List<Color> colors = [Colors.lightBlue,Colors.grey];
  List<bool> checked = [true,false,false,false];
  Widget mainDrawer(){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: FlutterLogo(
                colors: Colors.lightBlue,//设置颜色
                size: 200,//设置大小
                textColor: Colors.blue,//用于在徽标上绘制“Flutter”文本的颜色，如果样式为
                duration: Duration(microseconds: 1),//是否绘制“颤动”文本。默认情况下，仅绘制徽标本身
                style: FlutterLogoStyle.horizontal ,//如果更改样式，颜色或 textColor属性，动画的时间长度
                curve: Curves.bounceIn,////如果样式，颜色或textColor 发生更改，则会生成徽标动画的曲线。
              )
          ),
          ListTile(
            leading: Icon(icons[0],color: (checked[0] ? colors[0]:colors[1])),
            title: Text('首页',style: TextStyle(
                color: (checked[0] ? colors[0]:colors[1])
            ),),
            onTap: () {
              setState(() {
                checked[0] = false;
                checked[1] = false;
                checked[2] = false;
                checked[3] = false;
                checked[0] = true;
                selectIndex = 0;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(icons[1], color: (checked[1] ? colors[0]:colors[1])),
            title: Text('翻译收藏夹',style: TextStyle(
                color: (checked[1] ? colors[0]:colors[1])
            ),),
            onTap: () {
              setState(() {
                checked[0] = false;
                checked[1] = false;
                checked[2] = false;
                checked[3] = false;
                checked[1] = true;
                selectIndex = 1;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(icons[2], color: (checked[2] ? colors[0]:colors[1])),
            title: Text('离线翻译',style: TextStyle(
                color: (checked[2] ? colors[0]:colors[1])
            ),),
            onTap: () {
              setState(() {
                checked[0] = false;
                checked[1] = false;
                checked[2] = false;
                checked[3] = false;
                checked[2] = true;
                selectIndex = 2;
              });
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(icons[3], color: (checked[3] ? colors[0]:colors[1])),
            title: Text('设置',style: TextStyle(
                color: (checked[3] ? colors[0]:colors[1])
            ),),
            onTap: () {
              setState(() {
                checked[0] = false;
                checked[1] = false;
                checked[2] = false;
                checked[3] = false;
                checked[3] = true;
                selectIndex = 3;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  final Translate translate;
  final GestureTapCallback onTop;//点击事件

  const ListItem({Key key,  this.onTop,this.translate}) : super(key: key);
  @override
  _ListItemState createState() => _ListItemState( this.onTop, this.key,this.translate);
}

class _ListItemState extends State<ListItem> {
  final Translate translate;
  final GestureTapCallback onTop;//点击事件
  final Key key;
  Icon icon = Icon(Icons.star_border,color: Colors.grey,);

  _ListItemState( this.onTop, this.key, this.translate);//是否收藏

  @override
  void initState() {
    super.initState();
    if(translate.isCollect){
      icon = Icon(Icons.star,color:Colors.yellow[600],);
    }else{
      icon = Icon(Icons.star_border,color: Colors.grey,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: 10,right: 10,bottom: 2),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
      ),
      child: Container(
          height: 70,
          padding: EdgeInsets.only(left: 20),
          child:  Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        child: Text(translate.target ?? "目标",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        child: Text(translate.result ?? "结果",
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: 15
                          ),),
                        alignment: Alignment.centerLeft,
                      ),
                    )
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  TranslateProvider provider = TranslateProvider();
                  translate.isCollect = !translate.isCollect;
                  provider.update(translate);
                  setState(() {
                    if(translate.isCollect){

                      icon = Icon(Icons.star,color: Colors.yellow[600],);
                    }else{
                      icon = Icon(Icons.star_border,color: Colors.grey,);
                    }
                  });
                  onTop();
                },
                icon: icon,
              )
            ],
          )
      ),
    );
  }
}


