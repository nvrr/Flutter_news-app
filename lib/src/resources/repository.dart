import "dart:async";
import "news_api_provider.dart";
import "news_db_provider.dart";
import "../models/item_model.dart";

class Repository {
  List<Source> sources = <Source>[
    newsDbProvider,
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];
 
 //Iterate Over sources when dbprovider get fetchTopIds implemented
  Future<List<int>> fetchTopIds() {
    return sources[1].fetchTopIds();
  }

  Future<ItemModel> fetchItem(int id) async{
    ItemModel item;
    var source;

    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }


    for (var cache in caches) {
      if (cache != source) {
        cache.addItemToDb(item);
      }
    }


    return item;
  } // Future<ItemModel> fetchItem end tag


  clearCache() async {
    for (var cache in caches) {
      await cache.clear();
    }
  }

}// repository class end tag


abstract class Source { 
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<int> addItemToDb(ItemModel item);
  Future<int> clear();
}


/*

Future<ItemModel> fetchItem(int id) async{
    
    var item = await dbProvider.fetchItem(id);
    if (item != null) {
      return item;
    }

    item = await apiProvider.fetchItem(id);
    dbProvider.addItemToDb(item);

    return item;
  }
  */