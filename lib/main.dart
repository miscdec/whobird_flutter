import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whobird_flutter/presentation/bloc/analysis/analysis_bloc.dart';
import 'package:whobird_flutter/presentation/bloc/history/history_bloc.dart';
import 'package:whobird_flutter/presentation/bloc/settings/settings_bloc.dart';
import 'package:whobird_flutter/presentation/screens/home_screen.dart';
import 'package:whobird_flutter/core/di/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Initialize dependency injection
  runApp(const WhoBirdApp());
}

class WhoBirdApp extends StatelessWidget {
  const WhoBirdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AnalysisBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<HistoryBloc>()..add(LoadHistory()),
        ),
        BlocProvider(
          create: (context) => di.sl<SettingsBloc>()..add(LoadSettings()),
        ),
      ],
      child: MaterialApp(
        title: 'whoBIRD',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}