import 'package:flutter/material.dart';
import 'create_requisition_section_card.dart';

class CreateRequisitionPlaceholderStep extends StatelessWidget {
  final String title;
  final String subtitle;

  const CreateRequisitionPlaceholderStep({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return CreateRequisitionSectionCard(
      title: title,
      subtitle: subtitle,
      child: Text(
        'This step is ready for its dedicated form section. The stepper, navigation, and provider-backed flow are now wired up so this content can be expanded cleanly.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
