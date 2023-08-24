import 'package:flutter/material.dart';
import 'package:tt9_betweener_challenge/core/util/api_response.dart';
import 'package:tt9_betweener_challenge/views/widgets/alert.dart';

void handelResponseStatus(Status status, BuildContext context,
    {String? message, void Function()? onComplete}) {
  if (status == Status.LOADING) {
    showAlert(context, message: message ?? 'logging...', isError: false);
  } else if (status == Status.ERROR) {
    showAlert(context, message: message ?? 'error');
  } else {
    showAlert(context, message: message ?? 'done successfully', isError: false);
    if (onComplete != null) {
      onComplete();
    }
  }
}
