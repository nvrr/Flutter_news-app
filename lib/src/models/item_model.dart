import 'dart:convert';

class ItemModel {
final int id;
final bool deleted;
final String type;
final String by;
final int time;
final String text;
final bool dead;
final int parent;
final List<int> kids;
final String url;
final String title;
final int descendants;

ItemModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
      deleted = parsedJson['deleted'],
      type = parsedJson['type'],
      by = parsedJson['by'],
      time = parsedJson['time'],
      text = parsedJson['text'],
      dead = parsedJson['dead'],
      parent = parsedJson['parent'],
      kids = parsedJson['kids'],
      url = parsedJson['url'],
      title = parsedJson['title'],
      descendants = parsedJson['descendants'];

ItemModel.fromDb(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
      deleted = parsedJson['deleted'] == 1,
      type = parsedJson['type'],
      by = parsedJson['by'],
      time = parsedJson['time'],
      text = parsedJson['text'],
      dead = parsedJson['dead'] == 1,
      parent = parsedJson['parent'],
      kids = jsonDecode(parsedJson['kids']),
      url = parsedJson['url'],
      title = parsedJson['title'],
      descendants = parsedJson['descendants'];


}


 }