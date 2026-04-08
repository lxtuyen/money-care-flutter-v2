import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/errors/exceptions.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> loginWithGoogle();
  Future<String> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });
  Future<String> forgotPassword(String email);
  Future<String> verifyOtp(String email, String otp);
  Future<String> resetPassword(String email, String newPassword);
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final ApiClient api;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  Future<void>? _googleSignInInitialization;

  AuthRemoteDatasourceImpl({required this.api});

  Future<void> _ensureGoogleSignInInitialized() {
    return _googleSignInInitialization ??= _googleSignIn.initialize();
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    User? firebaseUser;
    String? idToken;

    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      final cred = await FirebaseAuth.instance.signInWithPopup(provider);
      firebaseUser = cred.user;
      final oauthCred = cred.credential as OAuthCredential?;
      idToken = oauthCred?.idToken ?? await firebaseUser?.getIdToken();
    } else {
      await _ensureGoogleSignInInitialized();
      late final GoogleSignInAccount googleUser;
      try {
        googleUser = await _googleSignIn.authenticate();
      } catch (_) {
        throw const ServerException('\\u0110\\u0103ng nh\\u1eadp Google \\u0111\\u00e3 b\\u1ecb h\\u1ee7y');
      }
      final googleAuth = await googleUser.authentication;
      idToken = googleAuth.idToken;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final cred = await _firebaseAuth.signInWithCredential(credential);
      firebaseUser = cred.user;
    }

    if (firebaseUser == null || idToken == null) {
      throw const ServerException('\\u0110\\u0103ng xu\\u1ea5t ho\\u1eb7c kh\\u00f4ng l\\u1ea5y \\u0111\\u01b0\\u1ee3c Token do l\\u1ed7i c\\u1ea5u h\\u00ecnh');
    }

    final res = await api.post<UserModel>(
      ApiRoutes.googleLogin,
      body: {
        'idToken': idToken,
      },
      fromJsonT: (json) => UserModel.fromAuthJson(json['user'], json['accessToken']),
    );

    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : '\\u0110\\u0103ng nh\\u1eadp Google th\\u1ea5t b\\u1ea1i',
      );
    }

    return res.data!;
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final res = await api.post<UserModel>(
      ApiRoutes.login,
      body: {'email': email, 'password': password},
      fromJsonT: (json) => UserModel.fromAuthJson(json['user'], json['accessToken']),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : '\\u0110\\u0103ng nh\\u1eadp th\\u1ea5t b\\u1ea1i',
      );
    }
    return res.data!;
  }

  @override
  Future<String> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    final res = await api.post<void>(
      ApiRoutes.register,
      body: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      },
    );
    if (!res.success) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : '\\u0110\\u0103ng k\\u00fd th\\u1ea5t b\\u1ea1i',
      );
    }
    return res.message;
  }

  @override
  Future<String> forgotPassword(String email) async {
    final res = await api.post<void>(
      ApiRoutes.forgotPassword,
      body: {'email': email},
    );
    if (!res.success) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Kh\\u00f4ng th\\u1ec3 g\\u1eedi m\\u00e3 OTP',
      );
    }
    return res.message;
  }

  @override
  Future<String> verifyOtp(String email, String otp) async {
    final res = await api.post<void>(
      ApiRoutes.verifyOtp,
      body: {'email': email, 'otp': otp},
    );
    if (!res.success) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'X\\u00e1c nh\\u1eadn OTP th\\u1ea5t b\\u1ea1i',
      );
    }
    return res.message;
  }

  @override
  Future<String> resetPassword(String email, String newPassword) async {
    final res = await api.post<void>(
      ApiRoutes.resetPassword,
      body: {'email': email, 'newPassword': newPassword},
    );
    if (!res.success) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : '\\u0110\\u1ed5i m\\u1eadt kh\\u1ea9u th\\u1ea5t b\\u1ea1i',
      );
    }
    return res.message;
  }
}