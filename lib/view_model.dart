import 'dart:async';
import 'dart:math';

import 'package:covid_tatarstan/fake_message.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewModel {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<FakeMessage> _messages = [];
  final StreamController<List<FakeMessage>> _messagesController =
      StreamController();
  Stream<List<FakeMessage>> get messages => _messagesController.stream;
  bool _isRegistered = false;
  final Random rnd = new Random();
  String _passport;

  ViewModel() {
    _prefs.then((readyPrefs) {
      _passport = readyPrefs.getString('passport');
      if (_passport != null) {
        _showPasswordMessages();
      }
    });
  }

  void dispose() {
    _messagesController.close();
  }

  DateTime _getRandomDate() {
    return DateTime(2000, 1, 1, 7 + rnd.nextInt(13), rnd.nextInt(60));
  }

  int getRandom() {
    int ranNumber = 1000 + rnd.nextInt(9998 - 1000);
    return ranNumber;
  }

  Future<void> _savePassport(String passport) async {
    _passport = passport;
    final SharedPreferences prefs = await _prefs;
    prefs.setString("passport", passport);
    _showPasswordMessages();
  }

  void _showPasswordMessages() {
    final date = _getRandomDate();
    _generateOutgoingMessage('Регистрация#$_passport', date);
    _generateIncomingMessage(0, date: date);
  }

  void _generateOutgoingMessage(String text, DateTime date) {
    _messages.insert(
        0, FakeMessage(text: text, isIncoming: false, sendDate: date));
    _messagesController.add(_messages);
  }

  void _generateIncomingMessage(int type, {DateTime date}) {
    print('generating message $type');
    FakeMessage message;
    switch (type) {
      case 0:
        message = FakeMessage(
            text: 'Вы успешно зарегистрировались.\n'
                'Ваш индивидуальный код: ${getRandom()}-${getRandom()}-${getRandom()}\n'
                'Номер вашего Паспорта: $_passport\n'
                '------------------------\n'
                'Для выхода из дома отправьте смс, начинающееся со слова Цель и номером цели.\n'
                '1. посещение суда\n'
                '2. доставка несовершеннолетних в(из) образовательные организации\n'
                '3. посещение медицинской / ветеринарной организации\n'
                '4. участие в похоронах\n'
                '5. восстановление паспорта\n'
                '6. выезд на дачу(загородный дом) / возвращение с дачи (из загородного дома)\n'
                '7. посещение кредитных организаций и почтовых отделений\n'
                '8. доставка лекарств, продуктов питания и предметов первой необходимости, оказание помощи нетрудоспособным родственникам\n'
                '9. изменение места проживания(пребывания)\n'
                'Пример: Цель 1',
            isIncoming: true,
            sendDate: date);
        break;
      default:
        message = FakeMessage(
            text:
                'Ваш код для выхода: ${getRandom()}-${getRandom()}-${getRandom()}\n'
                'Номер Паспорта: $_passport\n'
                'Время: ${_getTimeInterval(date, _getHoursDuration(type))}\n'
                '\n'
                'Не забудьте паспорт!',
            isIncoming: true,
            sendDate: date);
    }
    _messages.insert(0, message);
    _messagesController.add(_messages);
  }

  int _getHoursDuration(int type) {
    if (type == 6) {
      return 2;
    } else if (type == 9) {
      return 6;
    } else {
      return 1;
    }
  }

  String _getTimeInterval(DateTime date, int hours) {
    final start = date ?? DateTime.now();
    final format = 'dd.MM.yyyy HH:mm';
    final end = start.add(Duration(hours: hours));
    return DateFormat(format).format(start) +
        ' - ' +
        DateFormat(format).format(end);
  }

  Future<void> generateMessage(String text) async {
    if (!_isRegistered && text.length > 1) {
      print('lets save password $text');
      _savePassport(text);
    } else {
      try {
        int aimNumber = int.parse(text);
        final date = DateTime.now();
        _generateOutgoingMessage('Цель $aimNumber', date);
        _generateIncomingMessage(aimNumber, date: date);
      } catch (e) {
        print(e);
      }
    }
  }
}
