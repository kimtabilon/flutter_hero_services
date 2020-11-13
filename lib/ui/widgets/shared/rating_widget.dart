import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('0.0', style: TextStyle(fontSize: 11.0, color: Color(0xff333333)),),
        Icon(Icons.star_border, size: 11.0,),
        Icon(Icons.star_border, size: 11.0,),
        Icon(Icons.star_border, size: 11.0,),
        Icon(Icons.star_border, size: 11.0,),
        Icon(Icons.star_border, size: 11.0,),
      ],
    );
  }
}
