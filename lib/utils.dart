import 'package:flutter/material.dart';

void showSnackbar({
  required BuildContext context,
  required String contentText,
}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  final snackbar = SnackBar(
    content: Text(contentText),
  );

  scaffoldMessenger.removeCurrentSnackBar();
  scaffoldMessenger.showSnackBar(snackbar);
}

void showSimpleAlertDialog({
  required String title,
  required String content,
  required BuildContext context,
}) async {
  await showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          )
        ],
      );
    },
  );
}
