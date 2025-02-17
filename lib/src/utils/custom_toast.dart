import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import '../widgets/app_text.dart';

abstract class Toast<T> {
  static void success(String message) {
    dismissAllToast(showAnim: true);
    showToastWidget(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Material(
          color: const Color(0xFF017442),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppText(
              message,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
      position: ToastPosition.center,
      duration: const Duration(seconds: 3),
    );
  }

  static T? failure<T>(String message, [T? returnValue]) {
    dismissAllToast(showAnim: true);
    showToastWidget(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Material(
          color: const Color(0xFFCD0E00),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppText(
              message,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
      position: ToastPosition.center,
      duration: const Duration(seconds: 3),
    );

    return returnValue;
  }

  static void warning(String message) {
    dismissAllToast(showAnim: true);
    showToastWidget(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Material(
          color: Colors.orange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppText(
              message,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
      position: ToastPosition.center,
      duration: const Duration(seconds: 3),
    );
  }

  static T? info<T>(String message, [T? returnValue]) {
    dismissAllToast(showAnim: true);
    showToastWidget(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Material(
          color: const Color(0xFF02355F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AppText(
              message,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ),
      position: ToastPosition.center,
      duration: const Duration(seconds: 3),
    );

    return null;
  }

  static void topLevelInfo(String message) {
    dismissAllToast(showAnim: true);
    showToastWidget(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Material(
            color: const Color(0xFF02355F),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AppText(
                message,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      position: ToastPosition.center,
      duration: const Duration(seconds: 3),
    );
  }
}
