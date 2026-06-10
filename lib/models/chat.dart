import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Chat {
  final String id;
  final String text;
  final String? photo;
  final bool isMe;

  Chat({required this.text, this.photo, this.isMe = false}) : id = uuid.v4();
}
