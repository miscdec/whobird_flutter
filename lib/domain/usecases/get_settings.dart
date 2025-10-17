import 'package:whobird_flutter/core/usecases/usecase.dart';
import 'package:whobird_flutter/domain/entities/app_settings.dart';
import 'package:whobird_flutter/domain/repositories/settings_repository.dart';

class GetSettings implements UseCase<AppSettings, NoParams> {
  final SettingsRepository repository;

  GetSettings(this.repository);

  @override
  Future<AppSettings> call(NoParams params) async {
    return await repository.getSettings();
  }
}