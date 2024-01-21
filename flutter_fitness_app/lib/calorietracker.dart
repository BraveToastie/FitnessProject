import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalorieTrackerPage extends StatefulWidget {
  @override
  _CalorieTrackerPageState createState() => _CalorieTrackerPageState();
}

class _CalorieTrackerPageState extends State<CalorieTrackerPage> {
  TextEditingController _consumedController = TextEditingController();
  TextEditingController _burntController = TextEditingController();
  int _totalConsumedCalories = 0;

  @override
  void initState() {
    super.initState();
    _loadTotalCalories();
  }

  Future<void> _loadTotalCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalConsumedCalories = prefs.getInt('totalCalories') ?? 0;
    });
  }

  Future<void> _saveTotalCalories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('totalCalories', _totalConsumedCalories);
  }

  void _addCalories() {
    if (_consumedController.text.isNotEmpty) {
      int calories = int.tryParse(_consumedController.text) ?? 0;
      setState(() {
        _totalConsumedCalories += calories;
        _consumedController.clear();
      });
      _saveTotalCalories();
    }
  }

  void _removeCalories() {
    if (_burntController.text.isNotEmpty) {
      int calories = int.tryParse(_burntController.text) ?? 0;
      setState(() {
        _totalConsumedCalories = (_totalConsumedCalories - calories)
            .clamp(0, double.infinity)
            .toInt();
        _burntController.clear();
      });
      _saveTotalCalories();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calorie Tracker"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Total Calories Consumed",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "$_totalConsumedCalories Calories",
              style: TextStyle(
                fontSize: 32.0,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _consumedController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Calories Consumed",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _addCalories,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
              ),
              child: Text("Add Calories"),
            ),
            SizedBox(height: 20.0),
            Text(
              "Enter Calories Burnt",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _burntController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Calories Burnt",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _removeCalories,
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Use red for removal
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
              ),
              child: Text("Remove Calories"),
            ),
          ],
        ),
      ),
    );
  }
}
