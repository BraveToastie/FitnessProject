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
  int _selectedSteps = 1000; // Default selected steps
  int _stepsTaken = 0;

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
        appBar: _currentIndex == 0
            ? AppBar(
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
              )
            : null,
        body: Stack(
          children: [
            Offstage(
              offstage: _currentIndex != 0,
              child: _buildHomeContent(),
            ),
            Offstage(
              offstage: _currentIndex < 1 || _currentIndex >= _pages.length,
              child: _pages[_currentIndex],
            ),
          ],
        ),
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

  Widget _buildHomeContent() {
    return Column(
      children: [
        _buildStepsDropdown(),
        SizedBox(height: 16),
        _buildProgressBar(),
      ],
    );
  }

  Widget _buildStepsDropdown() {
    List<DropdownMenuItem<int>> items = List.generate(
      10,
      (index) => DropdownMenuItem<int>(
        value: (index + 1) * 1000,
        child: Text('${(index + 1) * 1000} Steps'),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DropdownButton<int>(
            value: _selectedSteps,
            onChanged: (value) {
              setState(() {
                _selectedSteps = value!;
              });
            },
            items: items,
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _stepsTaken++; // Increment steps taken by 1
              });
            },
            child: Text('+1 Step'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    double progress = _stepsTaken / _selectedSteps;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    );
  }
}
