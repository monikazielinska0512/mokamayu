import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:mokamayu/constants/constants.dart';
import '../../generated/l10n.dart';
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
    items = Provider.of<WardrobeManager>(context, listen: false)
        .getFinalWardrobeItemList;
  }

  final focus = FocusNode();
  List<WardrobeItem> items = [];
  WardrobeItem _selectedWardrobeItem = WardrobeItem.init();

  bool containsWardrobeItem(String text) {
    final WardrobeItem result = items.firstWhere(
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
          suggestions: items
              .map((item) => SearchFieldListItem(item.name, item: item))
              .toList(),
          suggestionState: Suggestion.hidden,
          hasOverlay: true,
          controller: _searchController,
          hint: S.of(context).searchbar_wardrobe_item,
          maxSuggestionsInViewPort: 4,
          itemHeight: 100,
          inputType: TextInputType.text,
          onSuggestionTap: (SearchFieldListItem<WardrobeItem> x) {
            setState(() {
              _selectedWardrobeItem = x.item!;
            });
            context.goNamed('wardrobe-item', extra: _selectedWardrobeItem);
            focus.unfocus();
          },
          searchInputDecoration: InputDecoration(
              filled: true,
              fillColor: ColorsConstants.whiteAccent,
              labelStyle: TextStyles.paragraphRegular18(ColorsConstants.grey),
              hintStyle: TextStyles.paragraphRegular18(ColorsConstants.grey),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: ColorsConstants.whiteAccent, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: ColorsConstants.whiteAccent, width: 0.0),
              ),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14.0))),
              prefixIcon: const Icon(Icons.search),
              prefixIconColor: focus.hasFocus == false
                  ? ColorsConstants.grey
                  : ColorsConstants.darkBrick),
        ));
  }
}
