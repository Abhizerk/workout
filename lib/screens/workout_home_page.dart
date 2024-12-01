import 'package:flutter/material.dart';
import 'package:workout_tracker/widgets/workout_form.dart'; // Corrected import path
import 'package:workout_tracker/models/workout.dart'; // Adjust the path if needed
import 'package:workout_tracker/widgets/workout_list.dart'; // Corrected import path
import 'settings_page.dart'; // Corrected import path


class WorkoutHomePage extends StatefulWidget {
  const WorkoutHomePage({super.key});

  @override
  _WorkoutHomePageState createState() => _WorkoutHomePageState();
}

class _WorkoutHomePageState extends State<WorkoutHomePage> {
  final List<Workout> _workouts = [];
  String _filterDay = '';
  String _filterTime = '';
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    WorkoutPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class WorkoutPage extends StatefulWidget {
  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final List<Workout> _workouts = [];
  final double _caloriesGoal = 500.0;
  String _filterDay = '';
  String _filterTime = '';

  List<Workout> get _filteredWorkouts {
    return _workouts.where((workout) {
      final matchesDay = _filterDay.isEmpty || workout.day == _filterDay;
      final matchesTime = _filterTime.isEmpty || workout.time == _filterTime;
      return matchesDay && matchesTime;
    }).toList();
  }

  int get _totalCalories {
    return _workouts.fold<int>(0, (sum, workout) {
      return sum + workout.calories.toInt();
    });
  }

  void _addWorkout(Workout workout) {
    setState(() {
      _workouts.add(workout);
    });
  }

  void _deleteWorkout(int index) {
    setState(() {
      _workouts.removeAt(index);
    });
  }

  void _deleteAllWorkouts() {
    setState(() {
      _workouts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            WorkoutForm(
              onAddWorkout: _addWorkout,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _filterDay.isEmpty ? null : _filterDay,
                    hint: const Text('Filter by Day'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _filterDay = newValue!;
                      });
                    },
                    items: <String>[
                      '', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: DropdownButton<String>(
                    value: _filterTime.isEmpty ? null : _filterTime,
                    hint: const Text('Filter by Time'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _filterTime = newValue!;
                      });
                    },
                    items: <String>['', 'Morning', 'Evening', 'Night']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: WorkoutList(
                workouts: _filteredWorkouts,
                onDelete: _deleteWorkout,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addWorkout(Workout(
            exercise: 'Running',
            duration: 30.0,
            calories: 300.0,
            type: 'Cardio',
            day: 'Monday',
            time: 'Morning',
            notes: 'Run at park',
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
