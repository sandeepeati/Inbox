import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:sms/contact.dart';

class ChatViewer extends StatefulWidget {
  SmsThread _smsThread;

  ChatViewer({SmsThread smsThread}) {
    _smsThread = smsThread;
  }

  @override
  ChatView createState() => ChatView(smsThread: _smsThread);
}

class ChatView extends State<ChatViewer> {
  SmsThread _smsThread;
  List<SmsMessage> _smsMessages;
  TextEditingController _msgController = new TextEditingController();
  bool _isComposing = false;

  ChatView({SmsThread smsThread}) {
    _smsThread = smsThread;
    _smsMessages = _smsThread.messages;
  }

  void _handleOnChanged(String text) {
    setState(() {
      _isComposing = text.length > 0;
    });
  }

  void _sendSms(String text) {}

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(
        color: Theme.of(context).accentColor,
      ),
      child: new Container(
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _msgController,
                onSubmitted: _sendSms,
                onChanged: _handleOnChanged,
                decoration: InputDecoration.collapsed(
                  hintText: 'send msg',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 4.0,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                ),
                onPressed:
                    _isComposing ? () => _sendSms(_msgController.text) : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(_smsThread.contact.address),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) =>
                  _SmsMessage(text: _smsMessages[index].body),
              itemCount: _smsMessages.length,
            ),
          ),
          Divider(
            height: 1.0,
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          )
        ],
      ),
    );
  }
}

class _SmsMessage extends StatelessWidget {
  final String text;
  _SmsMessage({this.text});

  List<String> _wrappedText = new List<String>();


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 16.0),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(text),
              )
            ],
          )
        ],
      ),
    );
  }
}
