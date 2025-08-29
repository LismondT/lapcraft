
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithBottomNavBar extends StatefulWidget {
  final Widget child;

  const ScaffoldWithBottomNavBar({super.key, required this.child});

  @override
  State<StatefulWidget> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 14,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() { _currentIndex = index; });
          switch (index) {
            case 0:
              GoRouter.of(context).go('/products');
              break;
            case 1:
              GoRouter.of(context).go('/favorites');
              break;
            case 2:
              GoRouter.of(context).go('/cart');
              break;
            case 3:
              GoRouter.of(context).go('/profile');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.pets),
              label: 'Товары'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Избранное'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Корзина'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль'
          ),
        ]
      ),
    );
  }
}