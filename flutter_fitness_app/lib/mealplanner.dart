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
  TextEditingController _mealController = TextEditingController();
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
    String day = _dayController.text.trim();
    String newMeal = _mealController.text.trim();

    if (day.isNotEmpty && newMeal.isNotEmpty) {
      setState(() {
        mealsByDay[day] ??= [];
        mealsByDay[day]!.add(newMeal);
        _mealController.clear();
        _dayController.clear();
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
                    child: TextField(
                      controller: _dayController,
                      decoration: InputDecoration(
                        labelText: "Enter Day",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: TextField(
                      controller: _mealController,
                      decoration: InputDecoration(
                        labelText: "Enter Meal",
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "$day:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _removeDay(day),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.0),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: dayMeals.length,
                              itemBuilder: (context, mealIndex) {
                                return ListTile(
                                  title: Text(
                                    dayMeals[mealIndex],
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () =>
                                        _removeMeal(day, mealIndex),
                                  ),
                                );
                              },
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
