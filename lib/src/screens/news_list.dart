import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_list_tile.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    
    // THIS IS BAD!!!!!  DONT DO THIS!
    // TEMPORARY
    // REMEMBER BUILD METHODE INSIDE OF ANY GIVEN APPLICATION CAN BE CALLED MANY MANY TIMES
// SO right now any time the build methode called we r going to initiate a request off to some API that is then
// going to eventually initiate some change or render of our application
// Now in this very particualr case that is OK bcz the part of application that gets re-rendered is
// child to NewsList - in another words its streambuilder right here that is
// going render, but fetchingTopIds caused our NewList itself to render or to rebuild then
// we would immediately go into an infinite loop where we just constantly attemp to fetch 
// fetchtopIds again and again and again. evey time we get the list of topIds build gets called again and
// and we call fetchTopIds to fetch them again and that process repeats over and over
// But right now this is OK for every temporary testing step  
// after restart we got error we fix it in and why we get in next step
    bloc.fetchTopIds();

    return Scaffold(
      appBar: AppBar(
        title: Text('Top News')
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, int index) {
            bloc.fetchItem(snapshot.data[index]);

            return NewsListTile(
              itemId: snapshot.data[index],
              );
          }
        );
      }
    );
  }

}