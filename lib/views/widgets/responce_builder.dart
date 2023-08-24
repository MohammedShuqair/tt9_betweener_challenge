import "package:flutter/material.dart";
import "package:tt9_betweener_challenge/core/util/api_response.dart";

class ResponseBuilder<T> extends StatelessWidget {
  final ApiResponse<T> response;
  final Widget Function(BuildContext context, String? message)? onError;
  final Widget Function(BuildContext context, String? message)? onLoading;
  final Widget Function(BuildContext context, T? data, String? message)?
      onComplete;
  const ResponseBuilder(
      {Key? key,
      required this.response,
      this.onError,
      this.onLoading,
      required this.onComplete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (response.status == Status.ERROR && onError != null) {
      return onError!(context, response.message);
    } else if (response.status == Status.LOADING && onLoading != null) {
      return onLoading!(context, response.message);
    } else if (onError != null) {
      return onComplete!(context, response.data, response.message);
    } else {
      return const SizedBox();
    }
  }
}
