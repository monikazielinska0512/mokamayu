import 'package:flutter/material.dart';

import '../../widgets/drag_target_container.dart';

class OutfitsAddAttributesScreen extends StatefulWidget {
  OutfitsAddAttributesScreen({super.key, required this.map});
  Map<List<dynamic>, ContainerList> map = {};

  @override
  State<OutfitsAddAttributesScreen> createState() =>
      _OutfitsAddAttributesScreenState();
}

class _OutfitsAddAttributesScreenState
    extends State<OutfitsAddAttributesScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
