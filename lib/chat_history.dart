import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:contacts_service/contacts_service.dart';
import 'chat_viewer.dart';

class ChatHistory extends StatefulWidget {

  List<SmsThread> msgThreads = new List<SmsThread>();

  ChatHistory({List<SmsThread> msgThreads}) {
    this.msgThreads = msgThreads;
  }

  @override
  Chat createState() => Chat(msgHistory: msgThreads);
}

class Chat extends State<ChatHistory> {
  List<SmsThread> smsHistory = new List<SmsThread>();
  SmsReceiver receiver = new SmsReceiver();
  SmsQuery query = new SmsQuery();

  Chat({List<SmsThread> msgHistory}) {
    smsHistory = msgHistory;
  }

  @override
  void initState() {
    super.initState();
    receiver.onSmsReceived.listen((SmsMessage msg) => _rebuildChatHistory());
  }

  @override
  void dispose() {
    print('disposing sms receiver');
    query = null;
    super.dispose();
  }

  void _getChatHistory() async {
    smsHistory = await query.getAllThreads;
  }
  void _rebuildChatHistory() {
    setState(() {
      _getChatHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(
            height: 1.0,
          ),
      itemCount: smsHistory.length,
      itemBuilder: (BuildContext context, int index) {
        return Material(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatViewer(smsThread: smsHistory[index]),
                ),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                child: Text(
                  smsHistory[index].address[0],
                ),
              ),
              title: Text(
                smsHistory[index].address,
              ),
            ),
          ),
        );
      },
    );
  }
}
