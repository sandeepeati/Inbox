import 'package:flutter/material.dart';
import 'backdrop.dart';

void main() async {
  runApp(Inbox());
}

class Inbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Inbox',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Backdrop(
            frontLayer: Container(color: Colors.white,),
            backLayer: Container(color: Theme.of(context).primaryColor,),
            frontTitle: Text('Inbox'),
            backTitle: Text('Contacts')),
      ),
    );
  }
}
