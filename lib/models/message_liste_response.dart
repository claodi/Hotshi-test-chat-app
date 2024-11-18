class MessageListeResponse {
  MessageListeResponse({
    required this.data,
  });

  final List<Datum> data;

  factory MessageListeResponse.fromJson(Map<String, dynamic> json) {
    return MessageListeResponse(
      data: json["data"] == null
          ? []
          : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data.map((x) => x.toJson()).toList(),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? id;
  final int? userId;
  final String? content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json["id"],
      userId: json["user_id"],
      content: json["content"],
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "content": content,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
