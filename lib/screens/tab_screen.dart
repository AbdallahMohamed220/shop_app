import 'package:flutter/material.dart';
import 'package:food_app/screens/cart_screen.dart';
import 'package:food_app/screens/home_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/orders_screen.dart';
import 'package:food_app/screens/manage_data_screen.dart';
import 'package:bmnav/bmnav.dart' as bmnav;

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': MyHomePage(),
        'title': 'home',
      },
      {
        'page': FavoritesScreen(),
        'title': 'Search',
      },
      {
        'page': CartScreen(),
        'title': 'Favorite',
      },
      {'page': OrdersScreen(), 'title': 'order'},
      {
        'page': ManageData(),
        'title': 'account',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: bmnav.BottomNav(
        color: Theme.of(context).primaryColor,
        labelStyle: bmnav.LabelStyle(
            showOnSelect: true,
            onSelectTextStyle:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        index: _selectedPageIndex,
        iconStyle: bmnav.IconStyle(
            color: Colors.grey[100],
            onSelectColor: Colors.white,
            size: 20,
            onSelectSize: 35),
        onTap: (index) {
          _selectPage(index);
        },
        items: [
          bmnav.BottomNavItem(Icons.home, label: 'Home'),
          bmnav.BottomNavItem(Icons.favorite, label: 'Favorite'),
          bmnav.BottomNavItem(Icons.shopping_basket, label: 'Cart'),
          bmnav.BottomNavItem(Icons.today, label: 'Orders'),
          bmnav.BottomNavItem(Icons.person, label: 'Account')
        ],
      ),
    );
  }
}
