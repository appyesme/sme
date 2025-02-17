import 'package:freezed_annotation/freezed_annotation.dart';

import '../../add_post_page/models/post_model.dart';
import '../../services_list_page/models/service_model.dart';
import '../models/bank_account_model.dart';
import '../models/user_model.dart';

part 'state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const ProfileState._();

  const factory ProfileState({
    UserModel? user,
    List<PostModel>? posts,
    List<ServiceModel>? services,
    BankAccountModel? bankAccount,
  }) = _ProfileState;
}
