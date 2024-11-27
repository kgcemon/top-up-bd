import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key});

  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/loading.gif', // Image path
        width: 100, // Adjust width and height as needed
        height: 130,
      ),
    );
  }
}
