import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
   const Badge({
    Key? key,
    required this.child,
    required this.value,
    this.color,
  }) : super(key: key);

  final Widget child;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(  // Changed to a Container to control size and alignment
      padding: const EdgeInsets.all(2.0),
      constraints: const BoxConstraints(
        minWidth: 16,
        minHeight: 16,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          Positioned(
            right: 0,  // Adjusted the position to the top-right corner
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),  // Adjusted the border radius
                color: color ?? Colors.red,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,  // Adjusted the text color to white
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
