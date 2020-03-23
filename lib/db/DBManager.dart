
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableTranslate = "translate";
final String columnTarget = "target";
final String columnResult = "result";
final String columnCollect = "collect";
final String columnId = "id";

class Translate{
  String target;
  String result;
  bool isCollect = false;
  int id;


  Translate(this.target,this.result);


  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{
      columnTarget : target,
      columnResult : result,
      columnCollect : isCollect == true ? 1 : 0,
      columnId : id
    };
    return map;
  }

  Translate.formMap(Map<String,dynamic> map){
    target = map[columnTarget];
    result = map[columnResult];
    isCollect = map[columnCollect] == 1;
    id = map[columnId];
  }
}

class TranslateProvider{

  factory TranslateProvider() =>_translateProviderInstance();

  static TranslateProvider get translateProvider => _translateProvider;
  static TranslateProvider _translateProvider;
  static Database db;

  TranslateProvider._(){
    print("数据提供者创建完成");
  }

  Future<bool> initDatabase()async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath,'translate.db');
    await open(path);
    if(db != null){
      return true;
    }
    return false;
  }

  static TranslateProvider  _translateProviderInstance()  {
    if(_translateProvider == null){
      _translateProvider = TranslateProvider._();
    }
    return _translateProvider;
  }

  Future open(String path) async{
    db = await openDatabase(path,version: 1,onCreate: (db,version) async {
      await db.execute('''
      create table $tableTranslate (
      $columnId integer primary key autoincrement,
      $columnTarget text not null,
      $columnResult text not null,
      $columnCollect integer not null)
      ''');
    });
    //初始化数据库完成
    print("初始化数据库完成");
  }

  //插入一个元素
  Future<int> insert(Translate translate)async{
    int id = await db.insert(tableTranslate, translate.toMap());
    return id;
  }

  //获取所有的元素
  Future<List<Translate>> getAllTranslate() async{
    List<Translate> translates = [];
    List<Map<String,dynamic>> maps = await db.query(tableTranslate);
    for(Map map in maps){
      translates.add(Translate.formMap(map));
    }
    return translates;
  }

  //获取被收藏的元素
  Future<List<Translate>> getFavoriteTranslate() async{
    List<Translate> translates = [];
    List<Map<String,dynamic>> maps = await db.query(tableTranslate,columns: ['$columnCollect','$columnId','$columnResult','$columnTarget'],where: '$columnCollect = ?',whereArgs: [1]);
    int i =0;
    for(Map map in maps){
      translates.add(Translate.formMap(map));
    }
    return translates;
  }

  Future<int> delete(int id)async{

    return await db.delete(tableTranslate,where: '$columnId = ?',whereArgs: [id]);
  }

  Future<int> update(Translate translate)async{
    return await db.update(tableTranslate, translate.toMap(),where: '$columnId = ?',whereArgs: [translate.id]);
  }

  Future close() async {
    db.close();
  }
}
