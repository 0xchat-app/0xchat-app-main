import 'package:dio/dio.dart';
import 'base64.dart';
import 'package:http_parser/src/media_type.dart';
import 'uploader.dart';

class FileDropUploader {
  static var dio = Dio();

  /// Upload file to FileDrop server
  /// [serverUrl] The base URL of the FileDrop server (e.g., https://filedrop.besoeasy.com/)
  /// [filePath] Local file path to upload
  /// [fileName] Optional file name
  /// [onProgress] Optional progress callback
  static Future<String?> upload(
    String serverUrl,
    String filePath, {
    String? fileName,
    Function(double progress)? onProgress,
  }) async {
    // Ensure serverUrl ends with /
    if (!serverUrl.endsWith('/')) {
      serverUrl = '$serverUrl/';
    }
    
    final uploadUrl = '${serverUrl}upload';
    var fileType = Uploader.getFileType(filePath);
    MultipartFile? multipartFile;
    
    if (BASE64.check(filePath)) {
      var bytes = BASE64.toData(filePath);
      multipartFile = await MultipartFile.fromBytes(
        bytes,
        filename: fileName,
        contentType: MediaType.parse(fileType),
      );
    } else {
      multipartFile = await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: MediaType.parse(fileType),
      );
    }

    var formData = FormData.fromMap({'file': multipartFile});
    
    try {
      var response = await dio.post(
        uploadUrl,
        data: formData,
        onSendProgress: (count, total) {
          onProgress?.call(count / total);
        },
      );
      
      var body = response.data;
      // Handle different response formats
      if (body is Map<String, dynamic>) {
        // Extract MIME type from response if available
        String? mimeType;
        if (body.containsKey('mime_type')) {
          mimeType = body['mime_type'] as String?;
        } else if (body.containsKey('details') && body['details'] is Map) {
          final details = body['details'] as Map;
          if (details.containsKey('mime_type')) {
            mimeType = details['mime_type'] as String?;
          }
        }
        
        // Try common response field names
        String? url;
        if (body.containsKey('url')) {
          url = body['url'] as String?;
        } else if (body.containsKey('fileUrl')) {
          url = body['fileUrl'] as String?;
        } else if (body.containsKey('data') && body['data'] is Map) {
          final data = body['data'] as Map;
          if (data.containsKey('url')) {
            url = data['url'] as String?;
          }
        } else {
          // If response is a map but no URL found, return the first string value or null
          for (var value in body.values) {
            if (value is String && (value.startsWith('http://') || value.startsWith('https://'))) {
              url = value;
              break;
            }
          }
        }
        
        // Add MIME type to URL if available
        if (url != null && mimeType != null) {
          try {
            final uri = Uri.parse(url);
            final updatedUri = uri.replace(
              queryParameters: {
                ...uri.queryParameters,
                'm': mimeType, // Add MIME type as query parameter for message type identification
              },
            );
            return updatedUri.toString();
          } catch (e) {
            return url;
          }
        }
        
        if (url != null) {
          return url;
        }
      } else if (body is String) {
        // If response is a direct URL string
        if (body.startsWith('http://') || body.startsWith('https://')) {
          return body;
        }
      }
    } catch (e) {
      rethrow;
    }
    
    return null;
  }
}

