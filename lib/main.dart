import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whobird_flutter/core/providers.dart';
import 'package:whobird_flutter/domain/usecases/setup_application.dart';
import 'package:whobird_flutter/presentation/screens/home_screen.dart';
import 'package:whobird_flutter/presentation/screens/splash_screen.dart';
import 'package:whobird_flutter/core/usecases/usecase.dart';

// A provider for our setup use case
final setupUseCaseProvider = Provider<SetupApplicationUseCase>((ref) {
  return SetupApplicationUseCase(
    modelRepository: ref.watch(modelRepositoryProvider),
  );
});

// A future provider to run the setup logic
final setupFutureProvider = FutureProvider<void>((ref) async {
  final setupUseCase = ref.watch(setupUseCaseProvider);
  await setupUseCase.call(NoParams());
});


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: AppInitializer()));
}

class AppInitializer extends ConsumerWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(setupFutureProvider);

    return setup.when(
      data: (_) => const WhoBirdApp(),
      loading: () => const SplashScreen(),
      error: (err, stack) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Failed to initialize the app: $err')),
        ),
      ),
    );
  }
}

class WhoBirdApp extends StatelessWidget {
  const WhoBirdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'whoBIRD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}