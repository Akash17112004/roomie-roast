class RoomModel {
  final String roomId;
  final String roomName;
  final String roomCode;

  RoomModel({
    required this.roomId,
    required this.roomName,
    required this.roomCode,
  });

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'roomCode': roomCode,
    };
  }

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      roomId: map['roomId'],
      roomName: map['roomName'],
      roomCode: map['roomCode'],
    );
  }
}