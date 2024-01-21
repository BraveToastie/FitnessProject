import 'package:flutter/material.dart';

class WorkoutPlannerPage extends StatefulWidget {
  @override
  _WorkoutPlannerPageState createState() => _WorkoutPlannerPageState();
}

class _WorkoutPlannerPageState extends State<WorkoutPlannerPage> {
  Map<String, List<Map<String, String>>> workoutsByDay = {};
  TextEditingController _workoutController = TextEditingController();
  TextEditingController _repsDurationController = TextEditingController();
  TextEditingController _dayController = TextEditingController();

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
      });
    }
  }

  void _removeWorkout(String day, int index) {
    setState(() {
      workoutsByDay[day]!.removeAt(index);
    });
  }

  void _removeDay(String day) {
    setState(() {
      workoutsByDay.remove(day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Workout Planner"),
        backgroundColor: Colors.blue, // Adjust the color as needed
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
                primary: Colors.blue, // Button color
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
