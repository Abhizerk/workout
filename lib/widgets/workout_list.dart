import 'package:flutter/material.dart';
import '../models/workout.dart';

class WorkoutList extends StatelessWidget {
  final List<Workout> workouts;
  final Function(int) onDelete;

  const WorkoutList({super.key, required this.workouts, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (ctx, index) {
        final workout = workouts[index];
        return ListTile(
          title: Text(workout.exercise),
          subtitle: Text('${workout.duration} min | ${workout.calories} cal'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(index),
          ),
        );
      },
    );
  }
}
