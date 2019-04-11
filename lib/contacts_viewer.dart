import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:sms/sms.dart';

import 'chat_viewer.dart';

class ContactsViewer extends StatelessWidget {
  List<Contact> contacts = new List<Contact>();
  List<SmsThread> _smsThreads = new List<SmsThread>();

  ContactsViewer({List<Contact> contacts, List<SmsThread> smsThreads}) {
    this.contacts = contacts;
    this._smsThreads = smsThreads;
  }

  SmsThread getSmsThread({Contact contact}) {
    for (SmsThread _smsThread in _smsThreads) {
      for (Item phone in contact.phones) {
        if (phone.value.contains(_smsThread.address) ||
            _smsThread.address.contains(phone.value)) return _smsThread;
      }
    }
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatViewer(
                        smsThread: getSmsThread(contact: contacts[index]),
                        address: contacts[index].phones.toList().first.value,
                      ),
                ),
              );
            },
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
