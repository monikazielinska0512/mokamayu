import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import '../../models/wardrobe_item.dart';
import '../../services/managers/wardrobe_manager.dart';

class WardrobeItemSearch extends StatefulWidget {
  WardrobeItemSearch({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<WardrobeItemSearch> createState() => _WardrobeItemSearchState();
}

class _WardrobeItemSearchState extends State<WardrobeItemSearch> {
  @override
  void dispose() {
    _searchController.dispose();
    focus.dispose();
    super.dispose();
  }

  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    countries = Provider.of<WardrobeManager>(context, listen: false)
        .getFinalWardrobeItemList;
  }

  final focus = FocusNode();
  List<WardrobeItem> countries = [];
  WardrobeItem _selectedWardrobeItem = WardrobeItem.init();

  bool containsWardrobeItem(String text) {
    final WardrobeItem result = countries.firstWhere(
        (WardrobeItem item) => item.name.toLowerCase() == text.toLowerCase(),
        orElse: () => WardrobeItem.init());

    if (result.name.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SearchField(
          focusNode: focus,
          suggestions: countries
              .map((item) => SearchFieldListItem(item.name, item: item))
              .toList(),
          suggestionState: Suggestion.hidden,
          hasOverlay: true,
          controller: _searchController,
          hint: 'Search by item name',
          maxSuggestionsInViewPort: 4,
          itemHeight: 45,
          inputType: TextInputType.text,
          onSuggestionTap: (SearchFieldListItem<WardrobeItem> x) {
            setState(() {
              _selectedWardrobeItem = x.item!;
            });
            context.goNamed('wardrobe-item', extra: _selectedWardrobeItem);
            focus.unfocus();
          },
        ));
  }
//     Expanded(
//         child: Center(
//             child: _selectedWardrobeItem.name.isEmpty
//                 ? Text('select WardrobeItem')
//                 : Text),
//   ],
// );
}

// class WardrobeItemDetail extends StatefulWidget {
//   final WardrobeItem? item;
//
//   WardrobeItemDetail({Key? key, required this.item}) : super(key: key);
//
//   @override
//   _WardrobeItemDetailState createState() => _WardrobeItemDetailState();
// }

// class _WardrobeItemDetailState extends State<WardrobeItemDetail> {
//   Widget dataWidget(String key, dynamic value) {
//     return Container(
//       alignment: Alignment.center,
//       padding: EdgeInsets.symmetric(
//           horizontal: MediaQuery.of(context).size.width * 0.15),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text('$key:'),
//           SizedBox(
//             width: 16,
//           ),
//           Flexible(
//             child: Text(
//               '$value',
//               style: const TextStyle(fontSize: 30),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           alignment: Alignment.center,
//           child: Text(
//             widget.item!.name,
//             style: TextStyle(fontSize: 40),
//           ),
//         ),
//         SizedBox(
//           height: 20,
//         ),
//         dataWidget('Population:', widget.item!.name),
//         dataWidget('Density', widget.item!.type),
//         dataWidget('Land Area (in Km\'s)', widget.item!.size)
//       ],
//     );
//   }
// }
