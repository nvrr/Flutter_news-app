import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: builContainer(),
          subtitle: builContainer(),
        ),
        Divider(height: 8.00),
      ],
    );
  }

  Widget builContainer()
 {
   return Container(
     color: Colors.grey[200],
     height: 24.0,
     width: 150.0,
     margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
   );
 }}