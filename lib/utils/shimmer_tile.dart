import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTile extends StatelessWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry margin;

  const ShimmerTile({
    Key? key,
    this.height,
    this.width,
    required this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF065293),
                offset: Offset(2.0, 2.0),
                blurRadius: 5.0,
                spreadRadius: 1.0,
              ),
              BoxShadow(
                color: Color(0xFF065293),
                offset: Offset(0.0, 0.0),
                blurRadius: 0.0,
                spreadRadius: 0.0,
              ),
            ],
            color: const Color(0xFF065293).withOpacity(0.2),
          ),
          child: Shimmer.fromColors(
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
            ),
            baseColor: const Color(0xFF065293).withOpacity(0.1),
            highlightColor: Colors.white.withOpacity(0.2),
          ),
        ),
        Container(
          margin: margin,
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ],
    );
  }
}
