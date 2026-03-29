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

  AuthRemoteDatasourceImpl({required this.api});

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
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw const ServerException('Đăng nhập Google đã bị hủy');
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
      throw const ServerException('Đăng xuất hoặc không lấy được Token do lỗi cấu hình');
    }

    final res = await api.post<UserModel>(
      ApiRoutes.googleLogin,
      body: {
        'idToken': idToken,
      },
      fromJsonT: (json) => UserModel.fromJson(json['user'], json['accessToken']),
    );

    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Đăng nhập Google thất bại',
      );
    }

    return res.data!;
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final res = await api.post<UserModel>(
      ApiRoutes.login,
      body: {'email': email, 'password': password},
      fromJsonT: (json) => UserModel.fromJson(json['user'], json['accessToken']),
    );
    if (!res.success || res.data == null) {
      throw ServerException(
        res.message.isNotEmpty ? res.message : 'Đăng nhập thất bại',
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
        res.message.isNotEmpty ? res.message : 'Đăng ký thất bại',
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
        res.message.isNotEmpty ? res.message : 'Không thể gửi mã OTP',
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
        res.message.isNotEmpty ? res.message : 'Xác nhận OTP thất bại',
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
        res.message.isNotEmpty ? res.message : 'Đổi mật khẩu thất bại',
      );
    }
    return res.message;
  }
}
