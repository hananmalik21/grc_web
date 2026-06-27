import 'package:grc/features/payroll/application/element_entries/controllers/add_element_form_controller.dart';
import 'package:grc/features/payroll/application/element_entries/states/add_element_form_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addElementFormProvider = AutoDisposeNotifierProvider<AddElementFormController, AddElementFormState>(
  AddElementFormController.new,
);
