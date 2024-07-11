import 'package:dilaundry/config/app_assets.dart';
import 'package:flutter/material.dart';

class ErrorBackground extends StatelessWidget {
  const ErrorBackground({
    super.key,
    required this.ratio,
    required this.message,
  });

  final double ratio;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ratio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              AppAssets.emptyBg,
              fit: BoxFit.cover,
            ),
          ),
          UnconstrainedBox(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
