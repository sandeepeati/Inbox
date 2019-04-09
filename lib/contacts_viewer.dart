import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactsViewer extends StatelessWidget {
  List<Contact> contacts = new List<Contact>();

  ContactsViewer({List<Contact> contacts}) {
    this.contacts = contacts;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(
          height: 1.0,
        ),
      itemCount: contacts.length,
      itemBuilder: (BuildContext context, int index) {
        return Material(
          child: InkWell(
            onTap: () {},
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  contacts[index].displayName[0],
                ),
              ),
              title: Text(
                contacts[index].displayName,
              ),
            ),
          ),
        );
      },
    );
  }
}
