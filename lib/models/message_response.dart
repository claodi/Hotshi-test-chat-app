class MessageResponse {
  MessageResponse({
    required this.data,
  });

  final Data? data;

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
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
