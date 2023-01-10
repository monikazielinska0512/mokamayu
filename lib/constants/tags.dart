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
    "Top",
    "Spodnie",
    "Dżinsy",
    "Bluza",
    "Bluza z kapturem",
    "Kurtka",
    "Marynarka",
    "Płaszcz",
    "Sweter",
    "Kardigan",
    "Strój kąpielowy",
    "Odzież sportowa",
    "Spódniczka",
    "Spodenki",
    "Piżama",
    "Buty",
    "Akcesoria",
  ];

  static List<String> getTypes(){
    types.sort();
    return types;
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
    'Wedding'
  ];

  static const List<String> seasons = ['Summer', 'Winter', 'Fall', 'Spring'];
}
