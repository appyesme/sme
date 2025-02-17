import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../widgets/app_back_button.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/text_field.dart';
import '../../models/bank_account_model.dart';
import '../../providers/provider.dart';

Future<BankAccountModel?> viewPaymentDetailsEditSheet(BuildContext context, BankAccountModel details) {
  return showModalBottomSheet<BankAccountModel?>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    enableDrag: true,
    useSafeArea: true,
    elevation: 0,
    barrierColor: Colors.black26,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            color: KColors.purple,
            child: const Row(
              children: [
                AppBackButton(iconColor: KColors.white),
                SizedBox(width: 5),
                Expanded(
                  child: AppText(
                    "Edit Payment Details",
                    fontSize: 18,
                    color: KColors.white,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: DraggableScrollableSheet(
              minChildSize: 0.4,
              initialChildSize: 1,
              maxChildSize: 1,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: AppText(
                          "Account Name",
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppTextField(
                        initialValue: details.accountName,
                        onChanged: (value) => details = details.copyWith(accountName: value),
                        validator: (value) => value == null || value.isEmpty ? "Required" : null,
                        hintText: "Enter account name",
                        // height: 45,
                      ),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: AppText(
                          "Account Number",
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppTextField(
                        onChanged: (value) => details = details.copyWith(accountNumber: value),
                        initialValue: details.accountNumber,
                        hintText: "Enter account number",
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: AppText(
                          "IFSC code",
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppTextField(
                        onChanged: (value) => details = details.copyWith(ifscCode: value),
                        initialValue: details.ifscCode,
                        hintText: "Enter ifsc code",
                      ),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: AppText(
                          "UPI",
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      AppTextField(
                        onChanged: (value) => details = details.copyWith(upi: value),
                        initialValue: details.upi,
                        hintText: "Enter your upi id",
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Consumer(
                          builder: (_, ref, __) {
                            return AppButton(
                              onTap: () {
                                ref.read(profileProvider.notifier).onPaymentDetailsSaveTap(context, details);
                              },
                              width: 120,
                              text: "Save",
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
