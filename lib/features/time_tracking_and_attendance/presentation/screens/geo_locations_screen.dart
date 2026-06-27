import 'package:grc/core/widgets/feedback/placeholder_screen.dart';
import 'package:flutter/material.dart';

class GeoLocationsScreen extends StatelessWidget {
  const GeoLocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Geo Locations',
      subtitle: 'Configure and manage geo location settings for attendance tracking.',
    );
  }
}
