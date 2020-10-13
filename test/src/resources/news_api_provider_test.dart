import 'package:news/src/resources/news_api_provider.dart';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

void main() {
  test('FetchTopIds returns a list of ids',() async{
    // setup of test case
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async{
      return Response(json.encode([1,2,3,4]), 200);
    });

    final ids = await newsApi.fetchTopIds();

    //expectation
    expect(ids, [1,2,3,4]);
    
  });

  test('FetchItem returns a item model',() async{
    // setup of test case
    final newsApi = NewsApiProvider();
    newsApi.client = MockClient((request) async{
      final jsonMap = {'id': 123};
      return Response(json.encode(jsonMap), 200);
    });

    final item = await newsApi.fetchItem(999);//rather than 123 lets justdo like 999, i wouldn't want to pass in 123 here 
                                          // Bcz u will notice that iam passing in our response object has an idea of 123 and 
                                          // right now our test is not actually trying to make sure that like we're fetching the correct ID ,
                                          //we definitly could modify the test do that ,but i would not want to put 123 right here 
                                          //bcz that wouldn't make it seem like that's we were trying to make an assertion for that.

    //expectation
    expect(item.id, 123);
  });
}