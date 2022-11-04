import 'package:flutter/material.dart';

BottomAppBar NavBar(
    BuildContext context, int _selectedIndex, Function _onItemTapped, List<String> pageLabels) {
  return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 12,
      child: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          _onItemTapped(index);
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.checkroom_outlined),
            label: pageLabels[0],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.collections_outlined),
            label: pageLabels[1],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.event_outlined),
            label: pageLabels[2],
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outlined),
            label: pageLabels[3],
          ),
        ],
      ));
}
