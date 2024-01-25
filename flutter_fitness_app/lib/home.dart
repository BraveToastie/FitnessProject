import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'calorietracker.dart';
import 'mealplanner.dart';
import 'workoutdiary.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;

  //Link the other page files to the buttons on the navigator bar
  //Buttons are assigned to pages in the order of listing here.
  final List<Widget> _pages = [
    Center(child: Text("This is the home page")), // Home page content
    CalorieTrackerPage(),
    WorkoutPlannerPage(),
    MealPlannerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Fitness App - Home Page"),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: Icon(Icons.lightbulb),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ],
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate),
              label: 'Calorie Tracker',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Workout Planner',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'Meal Diary',
            ),
          ],
        ),
      ),
    );
  }
}
