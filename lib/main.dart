import 'package:flutter/material.dart';
import 'backdrop.dart';
import 'package:contacts_service/contacts_service.dart';
import 'contacts_viewer.dart';
import 'chat_history.dart';

void main() async {
  Iterable<Contact> contacts = await ContactsService.getContacts();
  runApp(Inbox(contacts: contacts.toList()));
}

class Inbox extends StatelessWidget {
  List<Contact> contacts = new List<Contact>();

  Inbox({List<Contact> contacts}) {
    this.contacts = contacts;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Inbox',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Backdrop(
            frontLayer: ChatHistory(),
            backLayer: ContactsViewer(
              contacts: this.contacts,
            ),
            frontTitle: Text('Inbox'),
            backTitle: Text('Contacts')),
      ),
    );
  }
}
