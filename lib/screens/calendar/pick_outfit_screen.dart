import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../services/managers/outfit_manager.dart';
import '../../widgets/fundamental/basic_page.dart';
import '../../widgets/photo/photo_grid.dart';

class PickOutfitScreen extends StatelessWidget {
  const PickOutfitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
        type: "Pick outfits",
        leftButtonType: "back",
        isRightButtonVisible: true,
        rightButtonType: "go_forward",
        onPressed: () {
          context.push('/summarize-outfits-screen');
        },
        context: context,
        isFullScreen: true,
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return Column(children: [
      Expanded(
          child: PhotoGrid(
              type: "pick_outfits",
              outfitsList: Provider.of<OutfitManager>(context, listen: false)
                  .getOutfitList))
    ]);
  }
}
