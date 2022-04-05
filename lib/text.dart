import 'package:flutter/material.dart';
// import 'package:loader_overlay/loader_overlay.dart';

class TestWidget extends StatefulWidget {
  TestWidget({Key? key}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      // duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RotationTransition(
              turns: Tween(begin: 0.0, end: 12.0).animate(_controller),
              child: Icon(Icons.stars),
            ),
            ElevatedButton(
              child: Text("go"),
              onPressed: () {
                // context.loaderOverlay.show();
              },
            ),
            ElevatedButton(
              child: Text("reset"),
              onPressed: () => _controller.reset(),
            ),
          ],
        ),
      ),
    );
  }
}
