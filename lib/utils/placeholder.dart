import "package:flutter/material.dart";
import "dart:async";

class CustomPlaceholder extends StatefulWidget {
  @override
  _CustomPlaceholderState createState() => _CustomPlaceholderState();
}

class _CustomPlaceholderState extends State<CustomPlaceholder>
    with SingleTickerProviderStateMixin {
  double placeholderOpcaity = 0;
  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration.zero);
    super.initState();
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 1), () {
      try {
        animationController.forward();
      } catch (e) {}
    });
    return FadeTransition(
      opacity: animation,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
