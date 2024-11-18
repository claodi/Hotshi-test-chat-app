class LoginResponse {
  LoginResponse({
    required this.data,
  });

  final Data? data;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
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
    required this.name,
    required this.token,
  });

  final int? id;
  final String? name;
  final String? token;

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json["id"],
      name: json["name"],
      token: json["token"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "token": token,
      };
}
