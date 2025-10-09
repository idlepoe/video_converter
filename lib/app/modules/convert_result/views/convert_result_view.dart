import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/convert_result_controller.dart';

class ConvertResultView extends GetView<ConvertResultController> {
  const ConvertResultView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ConvertResultView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ConvertResultView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
