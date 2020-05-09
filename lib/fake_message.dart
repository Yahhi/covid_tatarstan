class FakeMessage {
  final String text;
  final bool isIncoming;
  final DateTime sendDate;

  FakeMessage({this.text, this.isIncoming, DateTime sendDate})
      : this.sendDate = sendDate ?? DateTime.now();
}
