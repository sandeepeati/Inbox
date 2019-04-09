import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

class ChatHistory extends StatefulWidget {
  @override
  Chat createState() => Chat();
}

class Chat extends State<ChatHistory> {
  List<SmsMessage> smsHistory = new List<SmsMessage>();
  SmsReceiver receiver = new SmsReceiver();

  @override
  void initState() {
    super.initState();
    receiver.onSmsReceived.listen((SmsMessage msg) => _rebuildChatHistory(msg));
  }

  @override
  void dispose() {
    receiver = null;
    super.dispose();
  }

  void _rebuildChatHistory(SmsMessage msg) {
    setState(() {
      smsHistory.add(msg);
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
            onTap: () {},
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