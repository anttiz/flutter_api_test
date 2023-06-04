import 'package:amazon_cognito_identity_dart_2/cognito.dart';

class User {
  String? username;
  String? email;
  String? name;
  String? password;
  bool confirmed = false;
  bool hasAccess = false;

  User({
    this.username,
    this.name,
    this.email,
    this.password
  });

  /// Decode user from Cognito User Attributes
  factory User.fromUserAttributes(List<CognitoUserAttribute> attributes) {
    final user = User();
    for (var attribute in attributes) {
      if (attribute.getName() == 'email') {
        user.email = attribute.getValue();
      } else if (attribute.getName() == 'name') {
        user.name = attribute.getValue();
      }
    }
    return user;
  }
}
