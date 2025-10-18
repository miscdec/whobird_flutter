import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:whobird_flutter/core/constants/constants.dart';
import 'package:whobird_flutter/data/datasources/remote_data_service.dart';
import 'package:whobird_flutter/domain/repositories/model_repository.dart';

class ModelRepositoryImpl implements ModelRepository {
  final RemoteDataService remoteDataService;

  ModelRepositoryImpl({required this.remoteDataService});

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  @override
  Future<bool> areModelsAvailable() async {
    final modelFile = await _localFile(kModelFileName);
    final metaModelFile = await _localFile(kMetaModelFileName);
    final labelsFile = await _localFile(kLabelsFileName);
    return modelFile.existsSync() && metaModelFile.existsSync() && labelsFile.existsSync();
  }

  @override
  Future<void> downloadModels() async {
    final path = await _localPath;
    // In a real app, you might want to run these downloads in parallel.
    await remoteDataService.downloadFile(kModelUrl, '$path/$kModelFileName');
    await remoteDataService.downloadFile(kMetaModelUrl, '$path/$kMetaModelFileName');
    await remoteDataService.downloadFile(kLabelsUrl, '$path/$kLabelsFileName');
  }
}