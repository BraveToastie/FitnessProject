import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'calorietracker.dart';
import 'mealplanner.dart';
import 'workoutdiary.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  final String username;

  Homepage({required this.username});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  late List<Widget> _pages;
  int _totalCaloriesConsumed = 0;

  @override
  void initState() {
    super.initState();
    _loadTotalCalories();
    _pages = [
      _buildHomeContent(), // Home page content
      CalorieTrackerPage(),
      WorkoutPlannerPage(),
      MealPlannerPage(),
    ];
  }

  Future<void> _loadTotalCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalCaloriesConsumed = prefs.getInt('totalCalories') ?? 0;
    });
  }

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
                title: Text("Your Fitness Home Page"),
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

  Widget _buildHomeContent() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final ThemeData theme = Theme.of(context);
        final Brightness brightness = theme.brightness;

        return Column(
          children: [
            SizedBox(height: 16),
            Text(
              'Welcome, ${widget.username}!', // Display the username
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calories eaten today',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  FutureBuilder(
                    future: _loadTotalCalories(),
                    builder:
                        (BuildContext context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Text(
                          '$_totalCaloriesConsumed Calories',
                          style: TextStyle(
                            fontSize: 16,
                            color: brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
