import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../../generated/l10n.dart';
import '../../services/managers/outfit_manager.dart';

class PickOutfitScreen extends StatelessWidget {
  const PickOutfitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicScreen(
        title: S.of(context).pick_outfits,
        leftButton: BackArrowButton(context),
        rightButton: GoForwardButton(() {
          context.push('/summarize-outfits-screen');
        }),
        context: context,
        isFullScreen: false,
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: ColorsConstants.mint.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12)),
        child: Column(children: [
          Expanded(
              child: PhotoGrid(
                  type: "pick_outfits",
                  outfitsList:
                      Provider.of<OutfitManager>(context, listen: false)
                          .getOutfitList)),
        ]));
  }
}
