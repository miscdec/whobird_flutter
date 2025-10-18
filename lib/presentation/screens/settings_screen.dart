import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whobird_flutter/domain/entities/app_settings.dart';
import 'package:whobird_flutter/presentation/bloc/settings/settings_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading || state is SettingsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SettingsFailure) {
            return Center(child: Text('Failed to load settings: ${state.message}'));
          }
          if (state is SettingsLoaded) {
            final settings = state.settings;
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
                    context.read<SettingsBloc>().add(SaveSettingsEvent(newSettings));
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
                    context.read<SettingsBloc>().add(SaveSettingsEvent(newSettings));
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
                    context.read<SettingsBloc>().add(SaveSettingsEvent(newSettings));
                  },
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}