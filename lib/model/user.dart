class User {
  String name;
  String email;
  String accessToken;
  String imageUri;

  User({this.name, this.email, this.accessToken, this.imageUri});

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
      };
}
