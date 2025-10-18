import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whobird_flutter/core/providers.dart';
import 'package:whobird_flutter/domain/entities/app_settings.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsyncValue = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: settingsAsyncValue.when(
        data: (settings) {
          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Show Bird Images'),
                value: settings.showImages,
                onChanged: (bool value) {
                  final newSettings = AppSettings(
                      probabilityThreshold: settings.probabilityThreshold,
                      showImages: value,
                      audioSource: settings.audioSource,
                      highPassFilterHz: settings.highPassFilterHz,
                      metaModelInfluence: settings.metaModelInfluence,
                      saveWavFiles: settings.saveWavFiles);
                  ref.read(settingsNotifierProvider.notifier).saveSettings(newSettings);
                },
              ),
              SwitchListTile(
                title: const Text('Save .wav Files'),
                value: settings.saveWavFiles,
                onChanged: (bool value) {
                  final newSettings = AppSettings(
                      probabilityThreshold: settings.probabilityThreshold,
                      showImages: settings.showImages,
                      audioSource: settings.audioSource,
                      highPassFilterHz: settings.highPassFilterHz,
                      metaModelInfluence: settings.metaModelInfluence,
                      saveWavFiles: value);
                  ref.read(settingsNotifierProvider.notifier).saveSettings(newSettings);
                },
              ),
              ListTile(
                title: const Text('Probability Threshold'),
                subtitle: Text('${(settings.probabilityThreshold * 100).toStringAsFixed(0)}%'),
              ),
              Slider(
                value: settings.probabilityThreshold,
                min: 0.1,
                max: 1.0,
                divisions: 9,
                label: '${(settings.probabilityThreshold * 100).toStringAsFixed(0)}%',
                onChanged: (double value) {
                   final newSettings = AppSettings(
                      probabilityThreshold: value,
                      showImages: settings.showImages,
                      audioSource: settings.audioSource,
                      highPassFilterHz: settings.highPassFilterHz,
                      metaModelInfluence: settings.metaModelInfluence,
                      saveWavFiles: settings.saveWavFiles);
                  ref.read(settingsNotifierProvider.notifier).saveSettings(newSettings);
                },
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Failed to load settings: $err')),
      ),
    );
  }
}