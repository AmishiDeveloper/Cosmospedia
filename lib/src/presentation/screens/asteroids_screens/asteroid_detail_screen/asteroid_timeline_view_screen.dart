import 'package:cosmospedia/src/data/model/asteroid_model/asteroid_lookup_model.dart';
import 'package:flutter/material.dart';

class AsteroidTimelineViewScreen extends StatefulWidget {

  final AsteroidLookUpModel lookupModel;
  const AsteroidTimelineViewScreen({super.key,required this.lookupModel});

  @override
  State<AsteroidTimelineViewScreen> createState() => _AsteroidTimelineViewScreenState();
}

class _AsteroidTimelineViewScreenState extends State<AsteroidTimelineViewScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
