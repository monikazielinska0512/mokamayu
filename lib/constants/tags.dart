import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class Tags {
  static const List<String> sizes = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
  ];

  static List<String> types = [
    "Sukienka",
    "Koszulka",
  ];

  static List<String> getTypes() {
    types.sort();
    return types;
  }

  static List<String> getLanguagesTypes(BuildContext context) {
    List<String> list = [
      S.of(context).dress,
      S.of(context).tshirt,
      S.of(context).top,
      S.of(context).trousers,
      S.of(context).jeans,
      S.of(context).sweatshirt,
      S.of(context).hoodie,
      S.of(context).jacket,
      S.of(context).blazer,
      S.of(context).coat,
      S.of(context).sweater,
      S.of(context).cardigan,
      S.of(context).swimsuit,
      S.of(context).sports,
      S.of(context).skirt,
      S.of(context).shorts,
      S.of(context).pyjama,
      S.of(context).shoes,
      S.of(context).accessories,
    ];
    list.sort();
    return list;
  }

  static const List<String> styles = [
    "School",
    "Classic",
    "Super",
    "Vintage",
    "Streetwear",
    "Classic1",
    "Super1",
    "Vintage1",
    "Streetwea1r",
  ];
}

class OutfitTags {
  static const List<String> styles = [
    'Active',
    'Party',
    'Work',
    'Casual',
    'Wedding',
    'Summer',
    'Winter',
    'Fall',
    'Spring'
  ];

  static const List<String> seasons = ['Summer', 'Winter', 'Fall', 'Spring', 'Active',
    'Party',
    'Work',
    'Casual'];
}
