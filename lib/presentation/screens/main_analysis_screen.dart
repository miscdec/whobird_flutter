import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whobird_flutter/core/providers.dart';

class MainAnalysisScreen extends ConsumerWidget {
  const MainAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisAsyncValue = ref.watch(analysisStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('whoBIRD Analysis'),
      ),
      body: Center(
        child: analysisAsyncValue.when(
          data: (detections) {
            return detections.isEmpty
                ? const Text('Listening...')
                : ListView.builder(
                    itemCount: detections.length,
                    itemBuilder: (context, index) {
                      final detection = detections[index];
                      return ListTile(
                        title: Text(detection.label),
                        trailing: Text(
                            '${(detection.score * 100).toStringAsFixed(1)}%'),
                      );
                    },
                  );
          },
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('An error occurred: $err'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // In Riverpod, managing the "start/stop" state can be done in various ways.
          // For simplicity, we can invalidate the provider to make it restart.
          // A more robust solution might use a StateProvider to hold the "is recording" state.
          // For now, we'll just refresh it to restart the process.
          ref.invalidate(analysisStreamProvider);
        },
        label: const Text('Start/Restart Analysis'),
        icon: const Icon(Icons.mic),
      ),
    );
  }
}