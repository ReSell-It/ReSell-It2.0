import 'package:flutter/material.dart';
import '/consts/consts.dart';
import 'customPainter.dart';

class MyHeader extends StatelessWidget {
  const MyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 250),
      painter: RPSCustomPainter(),
      child: Container(
        height: 150,
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(appIcon),
              height: 80.0,
            ),
            const SizedBox(width: 10.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'ReSell- It',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                Text('Sustainable Reuse'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
