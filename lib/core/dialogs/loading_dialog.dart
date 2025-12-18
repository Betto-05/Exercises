import 'package:flutter/material.dart';
import 'package:football/core/constants/animated_icons.dart';
import 'package:lottie/lottie.dart';

class LoadingDialog {
  static void show(BuildContext context, {String message = "Loading..."}) {
    showDialog(
      context: context,
      barrierDismissible: false, // لا يمكن إغلاقه بالضغط خارج النافذة
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: Container(
              width: 250,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lottie Animatieon
                  Lottie.asset(
                    AnimatedLottieIcons.animatedLodingIcon,
                    width: 70,
                  ),

                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}
