import 'package:flutter/material.dart';
import 'home_page.dart';
import 'food_page.dart';
import 'log_page.dart';
import 'profile_page.dart';
import 'exercise_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  static final List<Widget> _pages = [
    HomePage(onNavigate: null),
    FoodPage(),
    ExercisePage(),
    LogPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A237E), // Navy blue
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A237E).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            navigationBarTheme: NavigationBarThemeData(
              labelTextStyle: WidgetStateProperty.all(
                const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          child: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
              _animationController.reset();
              _animationController.forward();
            },
            height: 80,
            backgroundColor: Colors.transparent,
            indicatorColor: Colors.white.withOpacity(0.2),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard, color: Colors.white),
                selectedIcon: Icon(
                  Icons.dashboard,
                  color: Colors.white,
                  size: 28,
                ),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.fastfood, color: Colors.white),
                selectedIcon: Icon(
                  Icons.fastfood,
                  color: Colors.white,
                  size: 28,
                ),
                label: 'Add Food',
              ),
              NavigationDestination(
                icon: Icon(Icons.directions_run, color: Colors.white),
                selectedIcon: Icon(
                  Icons.directions_run,
                  color: Colors.white,
                  size: 28,
                ),
                label: 'Exercise',
              ),
              NavigationDestination(
                icon: Icon(Icons.list, color: Colors.white),
                selectedIcon: Icon(Icons.list, color: Colors.white, size: 28),
                label: 'Log',
              ),
              NavigationDestination(
                icon: Icon(Icons.person, color: Colors.white),
                selectedIcon: Icon(Icons.person, color: Colors.white, size: 28),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
