import 'package:flutter/material.dart';
import '../models/workout.dart';

class WorkoutForm extends StatefulWidget {
  final Function(Workout) onAddWorkout;

  const WorkoutForm({super.key, required this.onAddWorkout});

  @override
  _WorkoutFormState createState() => _WorkoutFormState();
}

class _WorkoutFormState extends State<WorkoutForm> {
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _selectedType = 'Cardio';
  String _selectedTime = 'Morning';
  String _selectedDay = 'Monday';

  void _submitForm() {
    final String exercise = _exerciseController.text;
    final String durationText = _durationController.text;
    final String caloriesText = _caloriesController.text;
    final String notes = _notesController.text;

    if (exercise.isEmpty || durationText.isEmpty || caloriesText.isEmpty) {
      return;
    }

    final double? duration = double.tryParse(durationText);
    final double? calories = double.tryParse(caloriesText);

    if (duration == null || calories == null) {
      return;
    }

    final workout = Workout(
      exercise: exercise,
      duration: duration,
      calories: calories,
      type: _selectedType,
      day: _selectedDay,
      time: _selectedTime,
      notes: notes,
    );

    widget.onAddWorkout(workout);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _exerciseController,
          decoration: const InputDecoration(labelText: 'Exercise'),
        ),
        TextField(
          controller: _durationController,
          decoration: const InputDecoration(labelText: 'Duration (min)'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _caloriesController,
          decoration: const InputDecoration(labelText: 'Calories'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(labelText: 'Notes'),
        ),
        const SizedBox(height: 10),
        DropdownButton<String>(
          value: _selectedDay,
          onChanged: (String? newValue) {
            setState(() {
              _selectedDay = newValue!;
            });
          },
          items: <String>[
            'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        DropdownButton<String>(
          value: _selectedTime,
          onChanged: (String? newValue) {
            setState(() {
              _selectedTime = newValue!;
            });
          },
          items: <String>['Morning', 'Evening', 'Night']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Add Workout'),
        ),
      ],
    );
  }
}
