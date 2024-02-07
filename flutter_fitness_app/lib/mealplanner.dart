import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MealPlannerPage extends StatefulWidget {
  @override
  _MealPlannerPageState createState() => _MealPlannerPageState();
}

class _MealPlannerPageState extends State<MealPlannerPage> {
  Map<String, List<String>> mealsByDay = {};
  String? _selectedDay;
  String? _selectedMeal;
  String? _customMeal;
  TextEditingController _customMealController = TextEditingController();
  TextEditingController _dayController = TextEditingController();

  final String _key = 'meal_planner_data';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String storedData = prefs.getString(_key) ?? '{}';

      setState(() {
        mealsByDay = (json.decode(storedData) as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            (value as List<dynamic>).cast<String>(),
          ),
        );
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  void _saveData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(_key, json.encode(mealsByDay));
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  void _addMeal() {
    if (_selectedDay != null &&
        (_selectedMeal != null || _customMeal != null)) {
      setState(() {
        mealsByDay[_selectedDay!] ??= [];
        if (_customMeal != null) {
          mealsByDay[_selectedDay!]!.add(_selectedMeal! + ' - "$_customMeal"');
        } else {
          mealsByDay[_selectedDay!]!.add(_selectedMeal!);
        }
        _saveData();
      });
    }
  }

  void _removeMeal(String day, int index) {
    setState(() {
      mealsByDay[day]!.removeAt(index);
      _saveData();
    });
  }

  void _removeDay(String day) {
    setState(() {
      mealsByDay.remove(day);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    List<String> daysOfTheWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    List<String> mealOptions = [
      'Breakfast',
      'Lunch',
      'Dinner',
      'Snack',
    ];

    return MaterialApp(
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Meal Planner"),
          backgroundColor: Colors.green,
          actions: [
            IconButton(
              icon: Icon(Icons.lightbulb),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDay,
                      decoration: InputDecoration(
                        labelText: 'Select Day',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedDay = newValue;
                        });
                      },
                      items: daysOfTheWeek.map((day) {
                        return DropdownMenuItem<String>(
                          value: day,
                          child: Text(day),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedMeal,
                      decoration: InputDecoration(
                        labelText: 'Select Meal',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedMeal = newValue;
                        });
                      },
                      items: mealOptions.map((meal) {
                        return DropdownMenuItem<String>(
                          value: meal,
                          child: Text(meal),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: _customMealController,
                      onChanged: (value) {
                        setState(() {
                          _customMeal = value.isNotEmpty ? value : null;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Meal',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: _addMeal,
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
                child: Text("Add Meal", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 20.0),
              Expanded(
                child: ListView.builder(
                  itemCount: mealsByDay.length,
                  itemBuilder: (context, dayIndex) {
                    String day = mealsByDay.keys.elementAt(dayIndex);
                    List<String> dayMeals = mealsByDay[day]!;

                    return Card(
                      elevation: 3.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              day,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: dayMeals.asMap().entries.map((entry) {
                                int index = entry.key;
                                String meal = entry.value;
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '      ${index + 1}. $meal',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () => _removeMeal(day, index),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 10.0),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _removeDay(day),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
