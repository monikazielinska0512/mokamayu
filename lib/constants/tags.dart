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
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48'
  ];

  // static List<String> types = [
  //   "Sukienka",
  //   "Koszulka",
  // ];

  // static List<String> getTypes() {
  //   types.sort();
  //   return types;
  // }

  static List<String> getLanguagesTypes(BuildContext context) {
    List<String> list = [
      S.of(context).dress,
      S.of(context).top,
      S.of(context).trousers,
      S.of(context).jeans,
      S.of(context).sweatshirt,
      S.of(context).hoodie,
      S.of(context).jacket,
      S.of(context).blazer,
      S.of(context).coat,
      S.of(context).tshirt,
      S.of(context).sweater,
      S.of(context).cardigan,
      S.of(context).swimsuit,
      S.of(context).sports,
      S.of(context).shorts,
      S.of(context).pyjama,
      S.of(context).shoes,
      S.of(context).accessories,
    ];
    list.sort();
    return list;
  }

  static List<String> getLanguagesStyles(BuildContext context) {
    List<String> list = [
      S.of(context).school,
      S.of(context).classic,
      S.of(context).sport,
      S.of(context).elegant,
      S.of(context).vintage,
      S.of(context).smart_casual,
      S.of(context).minimalism,
      S.of(context).retro,
      S.of(context).glamour,
      S.of(context).romantic,
      S.of(context).military,
      S.of(context).streetwear,
      S.of(context).boho,
    ];
    list.sort();
    return list;
  }

  static const List<String> styles = [
    "School",
    "Classic",
    "Sporty",
    "Elegant",
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
    'Wedding'
  ];


  static List<String> getLanguagesStyles(BuildContext context) {
    List<String> list = [
      S.of(context).active,
      S.of(context).party,
      S.of(context).casual,
      S.of(context).wedding,
      S.of(context).school,
      S.of(context).classic,
      S.of(context).sport,
      S.of(context).elegant,
      S.of(context).vintage,
      S.of(context).smart_casual,
      S.of(context).minimalism,
      S.of(context).retro,
      S.of(context).glamour,
      S.of(context).romantic,
      S.of(context).military,
      S.of(context).streetwear,
      S.of(context).boho,
    ];
    list.sort();
    return list;
  }

  static List<String> getSeasons(BuildContext context) {
    List<String> list = [
      S.of(context).spring,
      S.of(context).summer,
      S.of(context).autumn,
      S.of(context).winter,
    ];
    list.sort();
    return list;
  }

  static const List<String> seasons = ['Summer', 'Winter', 'Fall', 'Spring'];
}
