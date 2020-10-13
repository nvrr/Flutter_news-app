import 'package:sqflite/sqflite.dart';//database driver to allow us to interact with our database
import 'package:path_provider/path_provider.dart';//allow us to work with underlying file system
import 'dart:io';//allow us to work with device file system
import 'package:path/path.dart';//similar to path_provider ,allow us a little bit more stuff to work around with the underlying file system
import 'dart:async';
import '../models/item_model.dart';


class NewsDbProvider {
  Database db;  //the Database type coming from sqlite package //db represents connection to the actual database that is stored on our physical device
  

  init() async{
    
  }
}