import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalorieTrackerPage extends StatefulWidget {
  @override
  _CalorieTrackerPageState createState() => _CalorieTrackerPageState();
}

class _CalorieTrackerPageState extends State<CalorieTrackerPage> {
  int _totalConsumedCalories = 0;
  String _currentInput = '';

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

  void _updateInput(String value) {
    setState(() {
      _currentInput += value;
    });
  }

  void _clearInput() {
    setState(() {
      _currentInput = '';
    });
  }

  void _addInputToTotal() {
    if (_currentInput.isNotEmpty) {
      int calories = int.tryParse(_currentInput) ?? 0;
      setState(() {
        _totalConsumedCalories += calories;
        _currentInput = '';
      });
      _saveTotalCalories();
    }
  }

  void _removeInputFromTotal() {
    if (_currentInput.isNotEmpty) {
      int calories = int.tryParse(_currentInput) ?? 0;
      setState(() {
        _totalConsumedCalories = (_totalConsumedCalories - calories)
            .clamp(0, double.infinity)
            .toInt();
        _currentInput = '';
      });
      _saveTotalCalories();
    }
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
          title: Text("Calorie Tracker"),
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
              Container(
                height: 50.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Text(
                  _currentInput,
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNumberButton('1'),
                  _buildNumberButton('2'),
                  _buildNumberButton('3'),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNumberButton('4'),
                  _buildNumberButton('5'),
                  _buildNumberButton('6'),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNumberButton('7'),
                  _buildNumberButton('8'),
                  _buildNumberButton('9'),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNumberButton('0'),
                  ElevatedButton(
                    onPressed: () => _addInputToTotal(),
                    child: Text('Add'),
                  ),
                  ElevatedButton(
                    onPressed: () => _removeInputFromTotal(),
                    child: Text('Remove'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(String value) {
    return ElevatedButton(
      onPressed: () => _updateInput(value),
      child: Text(value),
    );
  }
}
