import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

/// Abstract interface for a service that fetches data from a remote source.
abstract class RemoteDataService {
  /// Downloads a file from the given [url] and saves it to the [savePath].
  Future<void> downloadFile(String url, String savePath);
}

/// An implementation of RemoteDataService that uses the `http` package.
class HttpModelDownloadService implements RemoteDataService {
  final http.Client client;

  HttpModelDownloadService({required this.client});

  @override
  Future<void> downloadFile(String url, String savePath) async {
    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);
      } else {
        // In a real app, this would throw a specific ServerFailure.
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors or other exceptions.
      print("Failed to download file: $e");
      rethrow;
    }
  }
}