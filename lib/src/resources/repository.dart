import "dart:async";
import "news_api_provider.dart";
import "news_db_provider.dart";
import "../models/item_model.dart";

class Repository {
  NewsApiProvider apiProvider = NewsApiProvider();
  NewsDbProvider dbProvider = NewsDbProvider();

  fetchTopIds() {}

  fetchItem() {}
  
}