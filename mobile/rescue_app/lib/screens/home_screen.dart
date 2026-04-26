import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';

import 'event_tab_screen.dart';
import 'groups_tab_screen.dart';
import 'map_tab_screen.dart';
import 'ptt_tab_screen.dart';
import 'users_tab_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<String> _titles = <String>[
    'משתמשים',
    'אירועים',
    'PTT',
    'קבוצות',
    'מפה',
  ];

  static const List<CurvedNavigationBarItem> _items = <CurvedNavigationBarItem>[
    CurvedNavigationBarItem(
      child: Icon(Icons.people),
      label: 'משתמשים',
    ),
    CurvedNavigationBarItem(
      child: Icon(Icons.warning),
      label: 'אירועים',
    ),
    CurvedNavigationBarItem(
      child: Icon(Icons.mic),
      label: 'PTT',
    ),
    CurvedNavigationBarItem(
      child: Icon(Icons.groups),
      label: 'קבוצות',
    ),
    CurvedNavigationBarItem(
      child: Icon(Icons.map),
      label: 'מפה',
    ),
  ];

  static const List<Widget> _screens = <Widget>[
    UsersTabScreen(),
    EventTabScreen(),
    PttTabScreen(),
    GroupsTabScreen(),
    MapTabScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        items: _items,
        color: Colors.purple.shade300,
        buttonBackgroundColor: Colors.deepPurple,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        animationDuration: const Duration(milliseconds: 300),
        height: 78,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
