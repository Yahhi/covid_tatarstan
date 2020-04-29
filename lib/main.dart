import 'dart:math';

import 'package:flutter/material.dart';
import 'package:covid_tatarstan/incoming_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> litems = [];
  List<bool> _isIcominga = [];
  bool _isRegistered = false;
  Random rnd = new Random();
  String _passport;

  ScrollController _scrollController = ScrollController();
  final myController = TextEditingController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((readyPrefs) {
      print("LOADEDE");
      setState(() {
        _passport = readyPrefs.getString('passport') ?? '0000000000';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
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
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  reverse: false,
                  controller: _scrollController,
                  itemCount: litems.length,
                  itemBuilder: (BuildContext ctxt, int index) {
                    return Message(litems[index], _isIcominga[index]);
                  }),
            ),
            Container(
              color: Colors.grey[200],
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () {},
                  ),
                  Container(
                      width: 200,
                      child: TextField(
                        decoration: InputDecoration.collapsed(
                          hintText: "SMS-сообщение",
                        ),
                        autofocus: false,
                        controller: myController,
                      )),
                  IconButton(
                    icon: Icon(Icons.mood),
                    onPressed: () {
                      litems.add("start");
                      _isIcominga.add(false);
                      setState(() {});
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    color: Colors.green,
                    onPressed: () {
                      if (myController.text != '') {
                        litems.add(myController.text);
                        _isIcominga.add(true);
                        checkSendMessage(myController.text);
                        myController.clear();
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  int getRandom() {
    int ranNumber = 1000 + rnd.nextInt(9998 - 1000);
    return ranNumber;
  }

  Future<void> _savePassport() async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("passport", _passport);
  }

  Future<void> checkSendMessage(String text) async {
    final SharedPreferences prefs = await _prefs;

    if (!_isRegistered && text.startsWith('Регистрация')) {
      int number = text.indexOf('#');
      _passport = text.substring(number + 1, text.length);
      litems.add('Вы успешно зарегистрировались.\n'
          'Ваш индивидуальный код: ${getRandom()}-${getRandom()}-${getRandom()}\n'
          'Номер вашего Паспорта: $_passport\n'
          '------------------------\n'
          'Для выхода из дома отправьте смс, начинающееся со слова Цель и номером цели.\n'
          '1. посещение суда\n'
          '2. доставка несовершеннолетних в(из) образовательные организации\n'
          '3. посещение медицинской / ветеринарной организации\n'
          '4. участие в похоронах\n'
          '5. восстановление паспорта\n'
          '6. выезд на дачу(загородный дом) / возвращение с дачи(из загородного дома)\n'
          '7. посещение кредитных организаций и почтовых отделений\n'
          '8. доставка лекарств, продуктов питания и предметов первой необходимости, оказание помощи нетрудоспособным родственникам\n'
          '9. изменение места проживания(пребывания)\n'
          'Пример: Цель 1');
      _isIcominga.add(false);
      _savePassport();
    } else {
      switch (text) {
        case 'Цель 6':
          {
            litems.add(
                'Ваш код для выхода: ${getRandom()}-${getRandom()}-${getRandom()}\n'
                'Номер Паспорта: $_passport\n'
                'Время: 13.04.2020 09:40 - 13.04.2020 10:40\n'
                '\n'
                'Не забудьте паспорт!');
            _isIcominga.add(false);
          }
          break;

        default:
          {
            litems.add('Фигня какая то пришла!!! $_passport');
            _isIcominga.add(false);
          }
          break;
      }
    }
  }
}
