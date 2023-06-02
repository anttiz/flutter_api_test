import 'dart:convert';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage extends CognitoStorage {
  SharedPreferences _prefs;
  Storage(this._prefs);

  @override
  Future getItem(String key) async {
    String item;
    try {
      item = json.decode(_prefs.getString(key)!);
    } catch (e) {
      return null;
    }
    return item;
  }

  @override
  Future setItem(String key, value) async {
    await _prefs.setString(key, json.encode(value));
    return getItem(key);
  }

  @override
  Future removeItem(String key) async {
    final item = getItem(key);
    await _prefs.remove(key);
    return item;
  }

  @override
  Future<void> clear() async {
    await _prefs.clear();
  }
}

class User {
  String? username;
  String? email;
  String? name;
  String? password;
  bool confirmed = false;
  bool hasAccess = false;

  User({this.username, this.name});

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

class UserService {
  final CognitoUserPool _userPool = CognitoUserPool(
    dotenv.env['USER_POOL_ID']!,
    dotenv.env['USER_POOL_CLIENT_ID']!,
  );

  CognitoUser? _cognitoUser;
  CognitoUserSession? _session;
  CognitoCredentials? credentials;

  /// Initiate user session from local storage if present
  Future<bool> init() async {
    final prefs = await SharedPreferences.getInstance();
    final storage = Storage(prefs);
    _userPool.storage = storage;
    _cognitoUser = await _userPool.getCurrentUser();
    if (_cognitoUser == null) {
      return false;
    }
    _session = await _cognitoUser!.getSession();
    return _session!.isValid();
  }

  /// Get existing user from session with his/her attributes
  Future<User?> getCurrentUser() async {
    if (_cognitoUser == null || _session == null) {
      return null;
    }
    if (!_session!.isValid()) {
      return null;
    }
    final attributes = await _cognitoUser!.getUserAttributes();
    if (attributes == null) {
      return null;
    }
    final user = User.fromUserAttributes(attributes);
    user.hasAccess = true;
    return user;
  }

  /// Retrieve user credentials -- for use with other AWS services
  Future<CognitoCredentials?> getCredentials() async {
    if (_cognitoUser == null || _session == null) {
      return null;
    }
    credentials = CognitoCredentials(dotenv.env['IDENTITY_POOL_ID']!, _userPool);
    await credentials!.getAwsCredentials(_session!.getIdToken().getJwtToken());
    return credentials;
  }

  Future<CognitoUserSession?> getSession() async {
    if (_session == null) {
      return null;
    }
    return _session;
  }

  /// Login user
  Future<User> login(String username, String password) async {
    _cognitoUser = CognitoUser(username, _userPool, storage: _userPool.storage);

    final authDetails = AuthenticationDetails(
      username: username,
      password: password,
    );

    bool isConfirmed;
    try {
      _session = await _cognitoUser!.authenticateUser(authDetails);
      isConfirmed = true;
    } on CognitoClientException catch (e) {
      if (e.code == 'UserNotConfirmedException') {
        isConfirmed = false;
      } else {
        rethrow;
      }
    }
    /*
    if (!_session.isValid()) {
      return null;
    }
    */

    final attributes = await _cognitoUser!.getUserAttributes();
    final user = User.fromUserAttributes(attributes!);
    user.confirmed = isConfirmed;
    user.hasAccess = true;

    return user;
  }

/*
  /// Confirm user's account with confirmation code sent to email
  Future<bool> confirmAccount(String email, String confirmationCode) async {
    _cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);

    return await _cognitoUser.confirmRegistration(confirmationCode);
  }

  /// Resend confirmation code to user's email
  Future<void> resendConfirmationCode(String email) async {
    _cognitoUser = CognitoUser(email, _userPool, storage: _userPool.storage);
    await _cognitoUser.resendConfirmationCode();
  }

  /// Check if user's current session is valid
  Future<bool> checkAuthenticated() async {
    if (_cognitoUser == null || _session == null) {
      return false;
    }
    return _session.isValid();
  }

  /// Sign upuser
  Future<User> signUp(String email, String password, String name) async {
    CognitoUserPoolData data;
    final userAttributes = [
      AttributeArg(name: 'name', value: name),
    ];
    data =
        await _userPool.signUp(email, password, userAttributes: userAttributes);

    final user = User();
    user.email = email;
    user.name = name;
    user.confirmed = data.userConfirmed;

    return user;
  }
  */

  Future<void> signOut() async {
    if (credentials != null) {
      await credentials!.resetAwsCredentials();
    }
    if (_cognitoUser != null) {
      return _cognitoUser!.signOut();
    }
  }
}
