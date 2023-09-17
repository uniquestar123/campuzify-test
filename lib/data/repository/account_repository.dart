import 'dart:io';

import 'package:masterstudy_app/core/cache/account_local.dart';
import 'package:masterstudy_app/data/datasources/account_datasource.dart';
import 'package:masterstudy_app/data/models/account/account.dart';

abstract class AccountRepository {
  Future<Account> getUserAccount();

  Future<Account> getAccountById(int? userId);

  Future editProfile({
    String? firstName,
    String? lastName,
    String? password,
    String? description,
    String? position,
    String? facebook,
    String? twitter,
    String? instagram,
    File? photo,
  });

  Future uploadProfilePhoto(File file);

  void saveAccountLocal(Account account);

  Future<List<Account>> getAccountLocal();

  Future deleteAccount({int accountId});
}

class AccountRepositoryImpl implements AccountRepository {
  final AccountLocalStorage _accountLocalStorage = AccountLocalStorage();
  final AccountDataSource _accountDataSource = AccountRemoteDataSource();

  @override
  Future<Account> getAccountById(int? accountId) async => await _accountDataSource.getAccount(accountId: accountId);

  @override
  Future<Account> getUserAccount() async => await _accountDataSource.getAccount();

  @override
  Future editProfile({
    String? firstName,
    String? lastName,
    String? password,
    String? description,
    String? position,
    String? facebook,
    String? twitter,
    String? instagram,
    File? photo,
  }) async {
    final editProfileResponse = await _accountDataSource.editProfile(
      firstName!,
      lastName!,
      password!,
      description!,
      position!,
      facebook!,
      instagram!,
      twitter!,
    );

    return editProfileResponse;
  }

  @override
  Future uploadProfilePhoto(File file) async {
    try {
      final uploadPhotoResponse = await _accountDataSource.uploadProfilePhoto(file);

      return uploadPhotoResponse;
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void saveAccountLocal(Account account) {
    return _accountLocalStorage.saveAccountLocal(account);
  }

  @override
  Future<List<Account>> getAccountLocal() async {
    return _accountLocalStorage.getAccountLocal();
  }

  @override
  Future deleteAccount({int? accountId}) async {
    return await _accountDataSource.deleteAccount(accountId: accountId);
  }
}
