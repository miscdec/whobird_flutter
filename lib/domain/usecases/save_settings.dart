import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/entities/app_settings.dart';
import 'package:whobird_flutter/domain/repositories/settings_repository.dart';

class SaveSettings implements UseCase<void, AppSettings> {
  final SettingsRepository repository;

  SaveSettings(this.repository);

  @override
  Future<void> call(AppSettings params) async {
    return await repository.saveSettings(params);
  }
}