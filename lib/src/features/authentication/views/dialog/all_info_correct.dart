import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';

Future<bool?> showAllInfoCorrectDialog(BuildContext context) {
  return showDialog<bool?>(
    context: context,
    barrierColor: Colors.black38,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20.px),
              const Icon(
                CupertinoIcons.info_circle,
                size: 56,
              ),
              SizedBox(height: 20.px),
              const AppText(
                "All information\nis correct",
                fontSize: 20,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 20.px),
              const AppText(
                "Your account will undergo a verification process. We'll notify you as soon as it’s done",
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.px),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      onTap: () => Navigator.of(context).pop<bool?>(false),
                      backgroundColor: KColors.black40,
                      text: "No",
                    ),
                  ),
                  SizedBox(width: 20.px),
                  Expanded(
                    child: AppButton(
                      onTap: () => Navigator.of(context).pop<bool?>(true),
                      text: "Yes",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
