class User {
  String name;
  String email;
  String accessToken;

  User({this.name, this.email, this.accessToken});

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
      };
}
