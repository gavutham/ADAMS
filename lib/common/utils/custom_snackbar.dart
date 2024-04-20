import 'package:adams/constants/theme.dart';
import 'package:flutter/material.dart';

class CustomSnackBar {
  final BuildContext context;

  const CustomSnackBar({required this.context});

  errorSnackBar(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );

  successSnackBar(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: accentColor,
        ),
      );
}
