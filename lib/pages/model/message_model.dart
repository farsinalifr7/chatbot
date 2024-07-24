class MessageModel {
  final String message;
  final bool isInput;
  final DateTime time;

  MessageModel(
      {required this.message, required this.isInput, required this.time});
}
