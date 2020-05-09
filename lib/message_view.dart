import 'package:covid_tatarstan/fake_message.dart';
import 'package:flutter/material.dart';

class MessageView extends StatelessWidget {
  final FakeMessage message;

  const MessageView(
    this.message, {
    Key key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      child: Column(
        crossAxisAlignment: message.isIncoming
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: message.isIncoming ? Color(0xFFE3F7EE) : Color(0xFFF2F2F2),
            ),
            child: Text(message.text),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            message.sendDate.hour.toString().padLeft(2, '0') +
                ':' +
                message.sendDate.minute.toString().padLeft(2, '0'),
            style: TextStyle(fontSize: 11.0),
          ),
        ],
      ),
    );
  }
}
