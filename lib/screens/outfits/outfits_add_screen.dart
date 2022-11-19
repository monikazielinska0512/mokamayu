import 'package:flutter/material.dart';
import 'package:mokamayu/models/clothes.dart';
import 'package:mokamayu/ui/widgets/widgets.dart';

class CreateOutfitPage extends StatelessWidget {
  CreateOutfitPage({Key? key, this.clothesList}) : super(key: key);
  Future<List<Clothes>>? clothesList;

  @override
  Widget build(BuildContext context) {
    // late Future<List<Clothes>> clothesList =
    //     Provider.of<ClothesProvider>(context, listen: false).getClothesList
    //         as Future<List<Clothes>>;
    print('reload');
    return Scaffold(
      appBar: customAppBar(context, "Create a look"),
      body: Column(
        children: <Widget>[
          const DragTargetContainer(),
          //categories for wardrobe
          //TODO
          //photos from wardrobe (button add if no photos) - scroll horizontally
          SizedBox(
            width: double.infinity,
            height: 300,
            child: PhotoGrid(
              clothesList: clothesList,
              scrollVertically: false,
            ),
          )
        ],
      ),
      //),
    );
  }
}
