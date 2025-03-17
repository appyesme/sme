import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/kcolors.dart';
import '../../../../widgets/app_text.dart';

Future<bool?> showJoiningAsDialog(BuildContext context) {
  return showDialog<bool?>(
    context: context,
    barrierColor: Colors.black38,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20.px),
              const Icon(
                CupertinoIcons.lasso,
                size: 56,
              ),
              SizedBox(height: 20.px),
              const AppText(
                "I want join this platform as",
                fontSize: 16,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.px),
              const AppText(
                "Service",
                fontSize: 18,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 20.px),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop<bool?>(false),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: KColors.black,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: AppText(
                            "Seeker",
                            fontSize: 12,
                            color: KColors.white,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.px),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop<bool?>(true),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: KColors.purple,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: AppText(
                            "Provider",
                            fontSize: 12,
                            color: KColors.white,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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
