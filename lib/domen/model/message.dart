class Message{
  const Message({required this.senderId , required this.receiverId , required this.messageType , required this.readed,required this.time , required this.text});
  final String senderId;
  final String receiverId;
  final bool readed;
  final DateTime time;  
  final String text;
  final MessageType messageType;

  Map<String , dynamic> toJson() =>{
    'receiverId' : receiverId,
    'senderId' : senderId,
    'readed' : readed,
    'time' : time,
    'text' : text,
    'messageType' : messageType.toJson(),
  };

  factory Message.fromJson(Map<String, dynamic> json) =>
      Message(
        receiverId: json['receiverId'],
        senderId: json['senderId'],
        time: json['time'].toDate(),
        text: json['text'],
        readed: true,
        messageType:
            MessageType.fromJson(json['messageType']),
      );
}

enum MessageType{
  text,
  image;
  String toJson() => name;
  factory MessageType.fromJson(String json) =>
      values.byName(json);
}