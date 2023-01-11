import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

IconButton BackArrowButton(BuildContext context, {String? backPath}) {
  return IconButton(
    onPressed: () {
      backPath != null ? context.go(backPath) : context.pop();
    },
    icon: const Icon(Icons.arrow_back_ios),
  );
}
