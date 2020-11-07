import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SpinkitSharedWidget extends StatelessWidget {
  final String type;

  SpinkitSharedWidget({this.type});

  @override
  Widget build(BuildContext context) {
    switch(type) {
      case'ThreeBounce':
        return Center(child: SpinKitThreeBounce(
          color: Color(0xff93CA68),
          size: 20.0,
        ));
        break;
      default:
        return Center(child: SpinKitThreeBounce(
          color: Color(0xff93CA68),
          size: 20.0,
        ));
        break;
    }
  }
}
