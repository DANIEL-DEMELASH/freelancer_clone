// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:freelancer_clone/screens/jobs_screen.dart';
import 'package:freelancer_clone/screens/profile_screen.dart';
import 'package:freelancer_clone/screens/search_companies_screen.dart';
import 'package:freelancer_clone/screens/upload_job_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final List<Widget> _screens = [
    const JobsScreen(),
    const SearchCompaniesScreen(),
    const UploadJobScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 60.0,
          items: const <Widget>[
            Icon(Icons.list, size: 19),
            Icon(Icons.search, size: 19),
            Icon(Icons.add, size: 19),
            Icon(Icons.person_pin, size: 19),
          ],
          color: Colors.orange.shade400,
          buttonBackgroundColor: Colors.orange.shade300,
          backgroundColor: Colors.blueAccent,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: _screens[_page]);
  }
}
