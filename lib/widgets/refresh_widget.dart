import 'package:flutter/material.dart';
import 'package:food_share/utils/palette.dart';

class RefreshWidget extends StatelessWidget {
  final Widget child;
  final Future Function() onRefresh;

  const RefreshWidget({Key? key, required this.child, required this.onRefresh})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      strokeWidth: 3.0,
        color: kBlue,
        child: child,
        onRefresh: onRefresh,
    );
  }
}
