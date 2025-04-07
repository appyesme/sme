import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../core/constants/kcolors.dart';
import '../widgets/app_text.dart';

abstract class DialogHelper {
  static pop(BuildContext context) => GoRouter.of(context).pop();
  static unfocus(BuildContext context) => FocusManager.instance.primaryFocus?.unfocus();

  static showloading(BuildContext context, {String text = 'Please hold on', bool isDismissible = true}) {
    showDialog(
      context: context,
      barrierDismissible: isDismissible,
      barrierColor: Colors.black38,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              color: KColors.white,
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 50.sp,
                width: 50.sp,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    const Spacer(),
                    const CupertinoActivityIndicator(radius: 18),
                    const Spacer(),
                    const SizedBox(height: 10),
                    AppText(
                      text,
                      height: 1,
                      color: Colors.black,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  static Future<bool?> showDeleteWarning(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black38,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 250,
                ),
                child: Material(
                  color: KColors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        const FittedBox(
                          child: Icon(
                            CupertinoIcons.delete,
                            size: 60,
                            color: KColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const AppText(
                          "Are you sure you want to delete ?",
                          color: Colors.black,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w400,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => GoRouter.of(context).pop<bool>(true),
                              child: const Padding(
                                padding: EdgeInsets.all(14.0),
                                child: AppText("Yes"),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => GoRouter.of(context).pop<bool>(false),
                              child: const Padding(
                                padding: EdgeInsets.all(14.0),
                                child: AppText("No"),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
