import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';

void main() async {
  try {
    final interpreter = await Interpreter.fromFile('assets/ml/intent_model.tflite');
    print('Input tensors:');
    for (var i = 0; i < interpreter.getInputTensors().length; i++) {
      final t = interpreter.getInputTensor(i);
      print('  Input $i: ${t.name}, shape: ${t.shape}, type: ${t.type}');
    }
    print('Output tensors:');
    for (var i = 0; i < interpreter.getOutputTensors().length; i++) {
      final t = interpreter.getOutputTensor(i);
      print('  Output $i: ${t.name}, shape: ${t.shape}, type: ${t.type}');
    }
    interpreter.close();
  } catch (e) {
    print('Error: $e');
  }
}
