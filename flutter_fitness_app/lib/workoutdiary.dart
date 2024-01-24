import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkoutPlannerPage extends StatefulWidget {
  @override
  _WorkoutPlannerPageState createState() => _WorkoutPlannerPageState();
}

class _WorkoutPlannerPageState extends State<WorkoutPlannerPage> {
  Map<String, List<Map<String, String>>> workoutsByDay = {};
  TextEditingController _workoutController = TextEditingController();
  TextEditingController _repsDurationController = TextEditingController();
  TextEditingController _dayController = TextEditingController();

  final String _key = 'workout_planner_data';

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
        workoutsByDay = (json.decode(storedData) as Map<String, dynamic>).map(
          (key, value) {
            List<Map<String, String>> workouts = [];
            if (value is List<dynamic>) {
              workouts = value
                  .whereType<Map<String, dynamic>>()
                  .map((item) => item.cast<String, String>())
                  .toList();
            }
            return MapEntry(key, workouts);
          },
        );
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  void _saveData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(_key, json.encode(workoutsByDay));
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  void _addWorkout() {
    String day = _dayController.text.trim();
    String newWorkout = _workoutController.text.trim();
    String repsDuration = _repsDurationController.text.trim();

    if (day.isNotEmpty && newWorkout.isNotEmpty && repsDuration.isNotEmpty) {
      setState(() {
        workoutsByDay[day] ??= [];
        workoutsByDay[day]!.add({
          'workout': newWorkout,
          'repsDuration': repsDuration,
        });
        _workoutController.clear();
        _repsDurationController.clear();
        _dayController.clear();
        _saveData();
      });
    }
  }

  void _removeWorkout(String day, int index) {
    setState(() {
      workoutsByDay[day]!.removeAt(index);
      _saveData();
    });
  }

  void _removeDay(String day) {
    setState(() {
      workoutsByDay.remove(day);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout Planner"),
        backgroundColor: Colors.blue,
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
                    controller: _workoutController,
                    decoration: InputDecoration(
                      labelText: "Enter Workout",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextField(
                    controller: _repsDurationController,
                    decoration: InputDecoration(
                      labelText: "Reps/Duration",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _addWorkout,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text("Add Workout", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: workoutsByDay.length,
                itemBuilder: (context, dayIndex) {
                  String day = workoutsByDay.keys.elementAt(dayIndex);
                  List<Map<String, String>> dayWorkouts = workoutsByDay[day]!;

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
                            itemCount: dayWorkouts.length,
                            itemBuilder: (context, workoutIndex) {
                              return ListTile(
                                title: Text(
                                  dayWorkouts[workoutIndex]['workout']!,
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                subtitle: Text(
                                  dayWorkouts[workoutIndex]['repsDuration']!,
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () =>
                                      _removeWorkout(day, workoutIndex),
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
    );
  }
}
