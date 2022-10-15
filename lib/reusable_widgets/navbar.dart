import 'package:flutter/material.dart';

BottomNavigationBar NavBar(
    BuildContext context, int _selectedIndex, Function _onItemTapped) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: _selectedIndex,
    onTap: (index) {
      _onItemTapped(index);
    },
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.checkroom_outlined),
        label: 'Closet',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.collections_outlined),
        label: 'Outfits',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.event_outlined),
        label: 'Calendar',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outlined),
        label: 'Profile',
      ),
    ],
  );
}
