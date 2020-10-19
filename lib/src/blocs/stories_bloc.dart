import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _items = BehaviorSubject<int>();

  Stream <Map<int, Future<ItemModel>>> items;

  // Getters to Streams
  Stream<List<int>> get topIds => _topIds.stream;

  // Getters to Sinks
  Function(int) get fetchItem => _items.sink.add;

  StoriesBloc() {
    // Gotcha -when we call transform on a stream it does not modify the original stream.
    // instead it returns new stream , so new stream is return from this 
    // "_items.stream.transform(_itemsTransformer());" line of code and that is the 
    // stream that we wanted to expose to the outside world
    // so we need to somehow take the stream that is produced by this line of 
    // code "_items.stream.transform(_itemsTransformer());" and make sure that everyone in outside
    // world can get access to it.  So in order to do so i'm going to add a new instance variable
    // up above at the top " items" --"Stream <Map<int, Future<ItemModel>>> items;"
    // so this is the instance variable thats going to hold a reference to the 
    // transform streamed stream that we just put together right below , so intialize items = "below code"

    // OK so now any time we create a new stories block
    // we immediately create a new behavior subjects we declare instance variable of items but we don't assign
    // of a value to its constructor function is invoked.
    // We take the items stream controller we take the stream off we apply a transform to it exactly one time
    // and then we return that transform streambed and assign it to this item's variable.
    // And so now everyone in the outside world all the outside widgets that exist can all listen to this item's Stream right here.
    items = _items.stream.transform(_itemsTransformer());
  }

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
