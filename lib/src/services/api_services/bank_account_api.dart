import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../../core/api/api_helper.dart';
import '../../features/profile_page/models/bank_account_model.dart';

@immutable
abstract class BankAccountApi {
  static Future<BankAccountModel?> getPaymentDetails() async {
    String path = "/bank-accounts";
    final response = await ApiHelper.get(path);
    response.fold((l) => log(l.message), (r) => log(r.data.toString()));
    return response.fold<BankAccountModel?>((l) => null, (r) => BankAccountModel.fromJson(r.data));
  }

  static Future<BankAccountModel?> updatePaymentDetails(BankAccountModel details) async {
    String path = "/bank-accounts";
    final response = await ApiHelper.post(path, body: {
      if (details.id != null) "id": details.id,
      "account_name": details.accountName,
      "account_number": details.accountNumber,
      "ifsc_code": details.ifscCode,
      "upi": details.upi,
    });
    return response.fold<BankAccountModel?>((l) => null, (r) => BankAccountModel.fromJson(r.data));
  }
}
