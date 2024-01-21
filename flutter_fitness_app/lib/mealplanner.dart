import 'package:flutter/material.dart';

class MealPlannerPage extends StatefulWidget {
  @override
  _MealPlannerPageState createState() => _MealPlannerPageState();
}

class _MealPlannerPageState extends State<MealPlannerPage> {
  Map<String, List<String>> mealsByDay = {};
  TextEditingController _mealController = TextEditingController();
  TextEditingController _dayController = TextEditingController();

  void _addMeal() {
    String day = _dayController.text.trim();
    String newMeal = _mealController.text.trim();

    if (day.isNotEmpty && newMeal.isNotEmpty) {
      setState(() {
        mealsByDay[day] ??= [];
        mealsByDay[day]!.add(newMeal);
        _mealController.clear();
        _dayController.clear();
      });
    }
  }

  void _removeMeal(String day, int index) {
    setState(() {
      mealsByDay[day]!.removeAt(index);
    });
  }

  void _removeDay(String day) {
    setState(() {
      mealsByDay.remove(day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal Planner"),
        backgroundColor: Colors.green, // Adjust the color as needed
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              child: Text("Add Meal"),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: mealsByDay.length,
                itemBuilder: (context, dayIndex) {
                  String day = mealsByDay.keys.elementAt(dayIndex);
                  List<String> dayMeals = mealsByDay[day]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$day:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _removeDay(day),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: dayMeals.length,
                        itemBuilder: (context, mealIndex) {
                          return ListTile(
                            title: Text(dayMeals[mealIndex]),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => _removeMeal(day, mealIndex),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
