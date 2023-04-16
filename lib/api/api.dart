import 'package:dio/dio.dart';
import 'dart:io';

typedef ProgressCallback = void Function(int sentBytes, int totalBytes);

class APIAccess {
  static Future<Map<String, dynamic>> detectNSFW(String imageUrl,
      {ProgressCallback? onSendProgress}) async {
    const url =
        'https://nsfw-images-detection-and-classification.p.rapidapi.com/adult-content';
    final headers = {
      'x-rapidapi-host':
          'nsfw-images-detection-and-classification.p.rapidapi.com',
      'x-rapidapi-key': '1bac68c893mshde81b70b593567fp12b3d1jsn7fc709380cc3',
      // 'Content-Type': 'application/json',
    };
    final body = {'url': imageUrl};

    try {
      final response = await Dio().post(
        url,
        options: Options(headers: headers),
        data: body,
        onSendProgress: onSendProgress,
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to detect NSFW content');
      }
    } catch (e) {
      throw Exception('Failed to detect NSFW content: $e');
    }
  }

  static Future<Map<String, dynamic>> detectNSFWFile(File imageFile,
      {ProgressCallback? onSendProgress}) async {
    const url =
        'https://nsfw-images-detection-and-classification.p.rapidapi.com/adult-content-file';
    final headers = {
      'x-rapidapi-host':
          'nsfw-images-detection-and-classification.p.rapidapi.com',
      'x-rapidapi-key': '1bac68c893mshde81b70b593567fp12b3d1jsn7fc709380cc3',
      'Content-Type': 'multipart/form-data',
    };
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(imageFile.path),
    });

    try {
      final response = await Dio().post(
        url,
        options: Options(headers: headers),
        data: formData,
        onSendProgress: onSendProgress,
      );
      // if (response.statusCode == 200) {
      print(response.data);
      return response.data;
      // } else {
      //   throw Exception('Failed to detect NSFW content');
      // }
    } on DioError catch (e) {
      throw Exception(
          'Failed to detect NSFW content: ${e.response!.data['message']}');
    }
  }
}
