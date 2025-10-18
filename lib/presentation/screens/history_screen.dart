import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whobird_flutter/core/providers.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsyncValue = ref.watch(historyNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Observation History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Clear History'),
                    content: const Text('Are you sure you want to delete all observations?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                      TextButton(
                        child: const Text('Clear'),
                        onPressed: () {
                          ref.read(historyNotifierProvider.notifier).clearHistory();
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
      body: historyAsyncValue.when(
        data: (observations) {
          if (observations.isEmpty) {
            return const Center(child: Text('No observations yet.'));
          }
          return ListView.builder(
            itemCount: observations.length,
            itemBuilder: (context, index) {
              final observation = observations[index];
              return ListTile(
                title: Text(observation.commonName),
                subtitle: Text(
                    '${observation.scientificName}\n${observation.timestamp.toIso8601String()}'),
                trailing: Text('${(observation.confidence * 100).toStringAsFixed(1)}%'),
                isThreeLine: true,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Failed to load history: $err')),
      ),
    );
  }
}