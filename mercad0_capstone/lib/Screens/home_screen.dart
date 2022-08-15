import 'package:flutter/material.dart';
import'package:get/get.dart';

import '../Auth/ProfilePage.dart';
import 'Catalog.dart';
class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   int _selectedIndex=0;
static const List<Widget> _pages = <Widget>[
  CatalogScreen(),
  Icon(
    Icons.chat,
    size: 150,
  ),
  ProfilePage()
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: Center(child: _pages.elementAt(_selectedIndex)),
  bottomNavigationBar: BottomNavigationBar(
   
    currentIndex: _selectedIndex,
    onTap: onItemTapped,
    items: const <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.chat),
        label: 'Chat',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
  ),
  
);
  }

  void onItemTapped(int index){
    setState(() {_selectedIndex=index;});
  }
}