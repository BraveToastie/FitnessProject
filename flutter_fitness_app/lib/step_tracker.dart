// In your Flutter code
import 'package:flutter/services.dart';

const platform = MethodChannel('stepsChannel');

int steps = 0;

Future<void> getSteps() async {
  try {
    final int result = await platform.invokeMethod('getSteps');
    steps = result;
  } on PlatformException catch (e) {
    print("Failed to get steps: '${e.message}'.");
  }
}
