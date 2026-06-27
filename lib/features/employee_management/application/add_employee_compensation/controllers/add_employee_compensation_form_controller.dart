import 'package:flutter/material.dart';

class AddEmployeeCompensationFormController {
  final TextEditingController planSearchController = TextEditingController();

  void dispose() {
    planSearchController.dispose();
  }
}
