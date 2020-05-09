import 'package:covid_tatarstan/fake_message.dart';
import 'package:flutter/material.dart';

import 'message_view.dart';
import 'view_model.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final myController = TextEditingController();
  final ViewModel viewModel = ViewModel();

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image(
              image: AssetImage('image/default-user-icon-64.png'),
              fit: BoxFit.contain,
              height: 48,
            ),
            Container(padding: const EdgeInsets.all(20.0), child: Text('2590')),
          ],
        ),
        leading: Icon(Icons.arrow_back),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.local_phone),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<FakeMessage>>(
              initialData: [],
              stream: viewModel.messages,
              builder: (context, snapshot) {
                final data = snapshot.data;
                return ListView.builder(
                    reverse: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return MessageView(data[index]);
                    });
              },
            ),
          ),
          Container(
            color: Colors.grey[200],
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: () {},
                ),
                Expanded(
                    child: TextField(
                  decoration: InputDecoration.collapsed(
                    hintText: "SMS-сообщение",
                  ),
                  autofocus: false,
                  controller: myController,
                )),
                IconButton(
                  icon: Icon(Icons.mood),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.green,
                  onPressed: () {
                    if (myController.text.isNotEmpty) {
                      viewModel.generateMessage(myController.text);
                      myController.clear();
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
