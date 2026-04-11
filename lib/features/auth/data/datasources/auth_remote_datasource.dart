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
        throw const ServerException('Dang nhap Google da bi huy');
      }
      final googleAuth = await googleUser.authentication;
      idToken = googleAuth.idToken;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final cred = await _firebaseAuth.signInWithCredential(credential);
      firebaseUser = cred.user;
    }

    if (firebaseUser == null || idToken == null) {
      throw const ServerException('Dang xuat hoac khong lay duoc token do loi cau hinh');
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
        res.message.isNotEmpty ? res.message : 'Dang nhap Google that bai',
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
        res.message.isNotEmpty ? res.message : 'Dang nhap that bai',
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
        res.message.isNotEmpty ? res.message : 'Dang ky that bai',
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
        res.message.isNotEmpty ? res.message : 'Khong the gui ma OTP',
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
        res.message.isNotEmpty ? res.message : 'Xac nhan OTP that bai',
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
        res.message.isNotEmpty ? res.message : 'Doi mat khau that bai',
      );
    }
    return res.message;
  }
}


