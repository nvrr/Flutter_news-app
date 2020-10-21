import 'package:flutter/material.dart';
import 'loading_container.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({this.itemId}); 

   Widget build(context) {
     final bloc = StoriesProvider.of(context);

     return StreamBuilder(
       stream: bloc.items,
       builder: (context, snapshot) {
         if (!snapshot.hasData) {
           return LoadingContainer();
         }
         
         return FutureBuilder(
           future: snapshot.data[itemId],
           builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
             if (!itemSnapshot.hasData) {
               return LoadingContainer();
             }

             return buildTile(itemSnapshot.data);
           }
         );
       }
     );
   }

   Widget buildTile(ItemModel item) {
     return Column(
       children: [
         ListTile(
           title: Text(item.title),
           subtitle: Text('${item.score} points'),
           trailing: Column(
             children: [
               Icon(
                 Icons.comment,
                 color: Colors.blue
                 ),
               Text('${item.descendants}')
             ]
           ),
         ),
         Divider(
           height: 8.0
         )
       ],
     );
   }
}