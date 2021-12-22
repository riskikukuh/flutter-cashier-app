import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Util {
  static showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  static showDialogAlert(BuildContext context, String title, String content,
      void Function() onPositiveButtonClicked) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Batal',
            ),
          ),
          ElevatedButton(
            onPressed: onPositiveButtonClicked,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
            ),
            child: const Text(
              'Hapus',
            ),
          ),
        ],
      ),
    );
  }

  static String hash(String password) {
    var key = utf8.encode('k4s1r@k3y@password');
    var bytes = utf8.encode(password);

    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);
    return digest.toString();
  }
}
