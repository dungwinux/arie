class User {
  String name;
  String email;
  String accessToken;
  String id;

  User({this.name, this.email, this.accessToken, this.id});

  Map<String, dynamic> toJson() => {
        'name': name,
        'gmailAddress': email,
        'accessToken': accessToken,
      };
}
