import 'package:sqflite/sqflite.dart';//database driver to allow us to interact with our database
import 'package:path_provider/path_provider.dart';//allow us to work with underlying file system
import 'dart:io';//allow us to work with device file system
import 'package:path/path.dart';//similar to path_provider ,allow us a little bit more stuff to work around with the underlying file system
import 'dart:async';
import '../models/item_model.dart';
import 'repository.dart';


class NewsDbProvider implements Source, Cache {
  Database db;  //the Database type coming from sqlite package //db represents connection to the actual database that is stored on our physical device
  
  // we create instance for this Newsprovider to use to reference
  // when we use this NewsProvider we expected to call this init() fuction before we actually make use of the thing 
  //so right now we r just creating a new instance of DbProvider down at the very bottom of file, we never call init() in it,unfortunatly we can't call here ,
  //but just as a very easy work around , we can just define our Constructor method inside this NewsDbProvider and Call the init() methode from here. so inside we define Constructor and call init()
  NewsDbProvider() {
    init();
  }

  Future<List<int>> fetchTopIds() {
    return null;
  }

  void init() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();// this function is provided to our file through the path provider module right here, 
          //the path provider module is specially made to work with mobile devices temporary directories or directories on mobile device
          //so by calling this function ,it returns a reference to folder on our mobile device where we safely somewhat permanently store different files
          //so this is reference to mobile directory
          //so we had imported the module dart io so that we could get access to this type of directory
          //bcz what this function is going to return
    final path = join(documentsDirectory.path, "items9.db");
    // path variable stores reference to the actual file path where we going to create our database 

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
          //allow us to send a arbitrary snippet of sequel to our database where will be executed
          //so inside this function we're going to pass in a String that contains sequel code to 
          // creat a new table inside database// so here code is very long we creat multi-line string
          // so for that we use three quots """ """
        newDb.execute("""
        CREATE TABLE Items
          (
            id INTEGER PRIMARY KEY,
            type TEXT,
            by TEXT,
            time INTEGER,
            text TEXT,
            parent INTEGER,
            kids BLOB,
            dead INTEGER,
            deleted INTEGER,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
          )
        """);
                        
      }
    );
  }


  Future<ItemModel>fetchItem(int id) async{
    final maps = await db.query(
      "Items",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }

    return null;
  }


   Future<int> addItemToDb(ItemModel item) {
    return db.insert(
      "Items", 
      item.toMap(),
      // below code ignores error conficts, here we have error of : we take data from database and save it again,thats the error
      conflictAlgorithm: ConflictAlgorithm.ignore,
      );
  }

  Future<int> clear() {
    return db.delete("Items");
  }


}
// if we we create two instances like NewsDbProvider() in both sources and caches in Repository.dart file,
//it creates two connections to database ,sqlite doesnt like it. 
// so we create intance in here and use newsDbProvider reference in repository file 

final newsDbProvider = NewsDbProvider();
