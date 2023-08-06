import 'package:flutter/material.dart';

class NetworkErrorMessage extends StatelessWidget {
  const NetworkErrorMessage({
    super.key,
    this.hint = 'please check internet connection',
  });
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Text(
      hint,
      maxLines: 2,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
    );
  }
}
