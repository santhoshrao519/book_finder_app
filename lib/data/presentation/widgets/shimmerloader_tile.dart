
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingTile extends StatelessWidget {
  const ShimmerLoadingTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListTile(
        leading: Container(width: 50, height: 70, color: Colors.white),
        title: Container(
            height: 14,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 5)),
        subtitle: Container(
            height: 12,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 5)),
      ),
    );
  }
}
