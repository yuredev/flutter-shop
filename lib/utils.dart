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
