import 'package:flutter/material.dart';
import 'backdrop.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:sms/sms.dart';
import 'contacts_viewer.dart';
import 'chat_history.dart';

void main() async {
  Iterable<Contact> contacts = await ContactsService.getContacts();
  SmsQuery query = new SmsQuery();
  List<SmsThread> messageThreads = await query.getAllThreads;
  runApp(Inbox(contacts: contacts.toList(), msgThreads: messageThreads,));
}

class Inbox extends StatelessWidget {
  List<Contact> contacts = new List<Contact>();
  List<SmsThread> msgThreads = new List<SmsThread>();

  Inbox({List<Contact> contacts, List<SmsThread> msgThreads}) {
    this.contacts = contacts;
    this.msgThreads = msgThreads;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Inbox',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Backdrop(
            frontLayer: ChatHistory(
              msgThreads: this.msgThreads,
            ),
            backLayer: ContactsViewer(
              contacts: this.contacts,
            ),
            frontTitle: Text('Inbox'),
            backTitle: Text('Contacts')),
      ),
    );
  }
}
