import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _items = BehaviorSubject<int>();

  // Getters to Streams
  Stream<List<int>> get topIds => _topIds.stream;

  // -------------------------------------- bad-----

  // Dont do this, its not good, it invokes _itemsTransformer for every widget individually
   // the problm is that every separate widget that tries to acess this getter, will run
   // this code "_items.stream.transform(_itemsTransformer())" and 
   //every separate one is going to gets own individual Cache object ,this is 
   // this is not shared with any other widgets,which is without a doubt not ideal
   // =>> all it means is that we need to make sure that 
   // we only try to apply this transformer "_itemsTransformer()" right here exactly
   // exactly one time to our stream
   get items => _items.stream.transform(_itemsTransformer());
  // here we need to make sure we only apply the tranform one time

  // -------------------------------------------- bad-----

  // Getters to Sinks
  Function(int) get fetchItem => _items.sink.add;

  fetchTopIds() async{
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, _index) {
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>> {},
    );
  }

  dispose() {
    _topIds.close();
    _items.close();
  }
}
