import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/exceptions/app_exception.dart';
import '../../../core/repositories/firebase_auth/auth_error_code.dart';
import '../../../core/repositories/firebase_auth/firebase_auth_repository.dart';
import '../../../core/utils/logger.dart';

final changeEmailAddressProvider = Provider<ChangeEmailAddress>(
  ChangeEmailAddress.new,
);

class ChangeEmailAddress {
  ChangeEmailAddress(this._ref);

  final Ref _ref;

  Future<void> call({required String newEmail, required String password})
  // ignore: unnecessary_async
  async {
    try {
      final repository = _ref.read(firebaseAuthRepositoryProvider);
      final oldEmail = repository.authUser?.email;
      if (oldEmail == null) {
        throw AppException(title: 'ログインしてください');
      }
      // TODO(shohei): 未実装
      throw AppException(
        title: 'メールアドレスの変更はFirebaseFunctionでしかできませんので実装してください',
      );
    } on FirebaseAuthException catch (e) {
      logger.shout(e);

      if (e.code == AuthErrorCode.authInvalidEmail.value ||
          e.code == AuthErrorCode.authMissingAndroidPkgName.value ||
          e.code == AuthErrorCode.authMissingContinueUri.value ||
          e.code == AuthErrorCode.authMissingIosBundleId.value ||
          e.code == AuthErrorCode.authInvalidContinueUri.value ||
          e.code == AuthErrorCode.authUnauthorizedContinueUri.value ||
          e.code == AuthErrorCode.authUserNotFound.value) {
        throw AppException(title: 'エラーが発生しました');
      } else {
        throw AppException(title: '不明なエラーです ${e.message}');
      }
    }
  }
}
