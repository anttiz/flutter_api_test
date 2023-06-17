import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_api_test/services/storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';


class UserService {
  static final CognitoUserPool _userPool = CognitoUserPool(
    dotenv.env['USER_POOL_ID']!,
    dotenv.env['USER_POOL_CLIENT_ID']!,
  );

  static CognitoUser? _cognitoUser;
  static CognitoUserSession? _session;
  static CognitoCredentials? credentials;

  /// Initiate user session from local storage if present
  static Future<bool> init() async {
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
  static Future<User?> getCurrentUser() async {
    UserService.init();
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
  static Future<CognitoCredentials?> getCredentials() async {
    if (_cognitoUser == null || _session == null) {
      return null;
    }
    credentials = CognitoCredentials(dotenv.env['IDENTITY_POOL_ID']!, _userPool);
    await credentials!.getAwsCredentials(_session!.getIdToken().getJwtToken());
    return credentials;
  }

  static Future<CognitoUserSession?> getSession() async {
    if (_session == null) {
      await UserService.init();
    }
    return _session;
  }

  /// Login user
  static Future<User> login(String username, String password) async {
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

  static Future<void> signOut() async {
    if (credentials != null) {
      await credentials!.resetAwsCredentials();
    }
    if (_cognitoUser != null) {
      return _cognitoUser!.signOut();
    }
  }
}
