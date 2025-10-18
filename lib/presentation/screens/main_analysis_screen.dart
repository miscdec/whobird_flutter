import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whobird_flutter/presentation/bloc/analysis/analysis_bloc.dart';

class MainAnalysisScreen extends StatelessWidget {
  const MainAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('whoBIRD Analysis'),
      ),
      body: BlocBuilder<AnalysisBloc, AnalysisState>(
        builder: (context, state) {
          if (state is AnalysisInProgress) {
            return Column(
              children: [
                Expanded(
                  child: state.detections.isEmpty
                      ? const Center(child: Text('Listening...'))
                      : ListView.builder(
                          itemCount: state.detections.length,
                          itemBuilder: (context, index) {
                            final detection = state.detections[index];
                            return ListTile(
                              title: Text(detection.label),
                              trailing: Text(
                                  '${(detection.score * 100).toStringAsFixed(1)}%'),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 16),
                _buildControlButton(context, isRecording: true),
                const SizedBox(height: 16),
              ],
            );
          }
          if (state is AnalysisPaused || state is AnalysisInitial) {
            return Center(
              child: _buildControlButton(context, isRecording: false),
            );
          }
          if (state is AnalysisFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('An error occurred: ${state.message}'),
                  const SizedBox(height: 16),
                  _buildControlButton(context, isRecording: false),
                ],
              ),
            );
          }
          return Container(
            child: Center(
              child: Text('Something went wrong: unknown state ${state.runtimeType}'),
            ),
          ); // Should not happen
        },
      ),
    );
  }

  Widget _buildControlButton(BuildContext context, {required bool isRecording}) {
    return FloatingActionButton.extended(
      onPressed: () {
        final bloc = context.read<AnalysisBloc>();
        if (isRecording) {

          bloc.add(StopAnalysis());
        } else {
          bloc.add(StartAnalysis());
        }
      },
      label: Text(isRecording ? 'Stop' : 'Start Analysis'),
      icon: Icon(isRecording ? Icons.stop : Icons.mic),
    );
  }
}