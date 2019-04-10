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
  SmsSender sender = new SmsSender();

  ChatView({SmsThread smsThread}) {
    _smsThread = smsThread;
    _smsMessages = _smsThread.messages;
  }

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  void _handleOnChanged(String text) {
    setState(() {
      _isComposing = text.length > 0;
    });
  }

  void _sendSms(BuildContext context, String text) async {
    String _address = _smsThread.address;

//    get simcards and let them choose the sim cards
    SimCardsProvider provider = new SimCardsProvider();
    List<SimCard> cards = await provider.getSimCards();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose Sim Cards'),
          content: Text('Choose a sim card to send sms'),
          actions: <Widget>[
            FlatButton(
              child: Text('SIM 1'),
              onPressed: () {
                _sendSMS(cards[0], _address, text);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('SIM 2'),
              onPressed: () {
                _sendSMS(cards[1], _address, text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

  }

  void _sendSMS(SimCard card, String _address, String text) {
    SmsMessage msg = new SmsMessage(_address, text);
    sender.sendSms(msg, simCard: card);
    _msgController.clear();

    sender.onSmsDelivered.listen((msg) => {
    setState(() {
      _smsThread.messages.insert(0, msg);
      _smsMessages = _smsThread.messages;
    })
    });
  }

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
                onSubmitted: (String text) =>
                    _sendSms(context, _msgController.text),
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
                onPressed: _isComposing
                    ? () => _sendSms(context, _msgController.text)
                    : null,
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
