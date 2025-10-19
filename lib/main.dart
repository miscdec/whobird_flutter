import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whobird_flutter/domain/usecases/setup_application.dart';
import 'package:whobird_flutter/presentation/bloc/analysis/analysis_bloc.dart';
import 'package:whobird_flutter/presentation/bloc/history/history_bloc.dart';
import 'package:whobird_flutter/presentation/bloc/settings/settings_bloc.dart';
import 'package:whobird_flutter/presentation/screens/home_screen.dart';
import 'package:whobird_flutter/core/di/injection_container.dart' as di;
import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/presentation/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init(); // Initialize dependency injection
  runApp(const AppInitializer());
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  Future<void>? _setupFuture;

  @override
  void initState() {
    super.initState();
    _setupFuture = di.sl<SetupApplicationUseCase>().call(NoParams());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _setupFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error.toString()}');
            // Handle setup error: show an error screen
            return MaterialApp(
              home: Scaffold(
                body: Center(child: Text(''
                    'Failed to initialize the app.'
                    'Please try again later.'
                    'Error: ${snapshot.error.toString()}'
                )),
              ),
            );
          }
          // When setup is complete, show the main app
          return const WhoBirdApp();
        }
        // While setting up, show a splash screen
        return const SplashScreen();
      },
    );
  }
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