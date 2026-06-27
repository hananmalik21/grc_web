class FlowMonitorParameterField {
  const FlowMonitorParameterField({required this.label, required this.value, this.isEmpty = false});

  final String label;
  final String value;
  final bool isEmpty;
}

class FlowMonitorParameters {
  const FlowMonitorParameters({required this.fields});

  final List<FlowMonitorParameterField> fields;
}
