import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whobird_flutter/presentation/bloc/history/history_bloc.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Observation History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              // Show a confirmation dialog before clearing
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Clear History'),
                    content: const Text('Are you sure you want to delete all observations?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Clear'),
                        onPressed: () {
                          context.read<HistoryBloc>().add(ClearHistory());
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoaded) {
            return ListView.builder(
              itemCount: state.observations.length,
              itemBuilder: (context, index) {
                final observation = state.observations[index];
                return ListTile(
                  title: Text(observation.commonName),
                  subtitle: Text(
                      '${observation.scientificName}\n${observation.timestamp.toIso8601String()}'),
                  trailing: Text('${(observation.confidence * 100).toStringAsFixed(1)}%'),
                  isThreeLine: true,
                );
              },
            );
          } else if (state is HistoryEmpty) {
            return const Center(child: Text('No observations yet.'));
          } else if (state is HistoryFailure) {
            return Center(child: Text('Failed to load history: ${state.message}'));
          }
          // The initial state will trigger the LoadHistory event in main.dart
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}