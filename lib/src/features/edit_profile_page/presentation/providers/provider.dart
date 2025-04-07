import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../services/api_services/users_apis.dart';
import '../../../../utils/custom_toast.dart';
import '../../../../utils/dailog_helper.dart';
import '../../../profile_page/models/user_model.dart';
import '../../../profile_page/providers/provider.dart';

final editProfileProvider = StateNotifierProvider.autoDispose<EditProfileNotifier, UserModel?>(
  (ref) {
    final notifier = EditProfileNotifier(ref);
    return notifier;
  },
);

class EditProfileNotifier extends StateNotifier<UserModel?> {
  final Ref ref;
  EditProfileNotifier(this.ref) : super(null);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void setState(UserModel? value) => state = value;

  void setUser(UserModel value) => setState(value);

  void update(UserModel? Function(UserModel? value) change) {
    final updated = change(state);
    setState(updated);
  }

  Future<void> onSaveTap(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (state == null) return;

    DialogHelper.unfocus(context);
    DialogHelper.showloading(context, text: "Updating...");
    final updated = await UsersApi.updateUserDetails(state!);
    DialogHelper.pop(context);
    if (updated != null) {
      ref.read(profileProvider.notifier).update((value) => value.copyWith(user: state));
      Toast.success("Details updated successfully!");
      context.pop();
    } else {
      Toast.failure("Unable to update user details");
    }
  }
}
