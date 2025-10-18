import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:whobird_flutter/domain/entities/app_settings.dart';
import 'package:whobird_flutter/presentation/bloc/settings/settings_bloc.dart';
import 'package:whobird_flutter/presentation/screens/settings_screen.dart';

// Mock BLoC for testing
class MockSettingsBloc extends Mock implements SettingsBloc {}

void main() {
  late MockSettingsBloc mockSettingsBloc;

  setUp(() {
    mockSettingsBloc = MockSettingsBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<SettingsBloc>.value(
        value: mockSettingsBloc,
        child: const SettingsScreen(),
      ),
    );
  }

  testWidgets('should display settings values when state is SettingsLoaded', (widgetTester) async {
    // Arrange
    const initialSettings = AppSettings(
      probabilityThreshold: 0.5,
      showImages: true,
      audioSource: 'Default',
      highPassFilterHz: 200,
      metaModelInfluence: 0.5,
      saveWavFiles: false,
    );
    when(() => mockSettingsBloc.state).thenReturn(const SettingsLoaded(initialSettings));

    // Act
    await widgetTester.pumpWidget(createWidgetUnderTest());

    // Assert
    expect(find.text('Show Bird Images'), findsOneWidget);
    expect(find.byType(SwitchListTile), findsNWidgets(2));
    final firstSwitch = widgetTester.widget<SwitchListTile>(find.byType(SwitchListTile).first);
    expect(firstSwitch.value, isTrue);

    expect(find.text('Probability Threshold'), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    final slider = widgetTester.widget<Slider>(find.byType(Slider));
    expect(slider.value, 0.5);
  });
}