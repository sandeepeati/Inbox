import 'package:flutter/material.dart';
import 'package:sms/sms.dart';
import 'package:sms/contact.dart';

class ChatViewer extends StatefulWidget {
  SmsThread _smsThread;
  String _address;

  ChatViewer({SmsThread smsThread, String address}) {
    _smsThread = smsThread;
    _address = address;
  }

  @override
  ChatView createState() => ChatView(smsThread: _smsThread, address: _address);
}

class ChatView extends State<ChatViewer> {
  SmsThread _smsThread;
  List<SmsMessage> _smsMessages;
  List<SimCard> _simCards;
  SimCard _selectedCard;
  ContactQuery _contactQuery = new ContactQuery();
  TextEditingController _msgController = new TextEditingController();
  String _contactName;
  String _address;
  bool _isComposing = false;
  SmsSender sender = new SmsSender();
  Contact _contact;

  ChatView({SmsThread smsThread, String address}) {
    _smsThread = smsThread;
    _smsMessages = _smsThread != null ? _smsThread.messages : <SmsMessage>[];

    _address = address;

    if (_smsThread == null) {
      _fillContactName(_address);
    }
  }

  @override
  void initState() {
    super.initState();
    getSimCards();
  }

  void _fillContactName(String address) async {
    _contact = await _contactQuery.queryContact(address);
    setState(() {
      _contactName = _contact.fullName;
    });
  }

  void getSimCards() async {
    SimCardsProvider provider = new SimCardsProvider();
    _simCards = await provider.getSimCards();

    Contact _contact = _smsThread != null ? _smsThread.contact : null;

    setState(() {
      if (_contactName == null) {
        _contactName = _contact.fullName;
        print(_contactName);
      }
    });
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
    String _address = _smsThread == null ? _contact.address : _smsThread.address;

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
    if (_smsMessages == null) _smsMessages = new List();
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _contactName != null ? _contactName : _smsThread.contact.address),
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

  @override
  Widget build(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.7;
    // TODO: implement build
    return Wrap(
      children: <Widget>[
        SizedBox(
          child: Container(
            padding: EdgeInsets.all(2.0),
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                10.0,
              )),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                maxLines: 6,
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
