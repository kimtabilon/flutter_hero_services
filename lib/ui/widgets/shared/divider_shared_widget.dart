import 'package:flutter/material.dart';

class DividerSharedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.4,
      width: double.infinity,
      color: Colors.grey,
      margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 20.0, bottom: 20.0),
    );
  }
}
