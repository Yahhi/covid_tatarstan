import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  final String message;
  final bool isIncoming;

  const Message(
    this.message,
    this.isIncoming, {
    Key key,
  });
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  var hour = DateTime.now().hour;
  var minutes = DateTime.now().minute;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        crossAxisAlignment: widget.isIncoming
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: widget.isIncoming ? Color(0xFFE3F7EE) : Color(0xFFF2F2F2),
            ),
            child: Text(widget.message),
          ),
          Text(
            hour.toString() + ':' + minutes.toString(),
            style: TextStyle(fontSize: 11.0),
          ),
        ],
      ),
    );
  }
}
