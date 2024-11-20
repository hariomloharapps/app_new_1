import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerificationResponse {
  final bool verificationStatus;
  final bool humanDetected;
  final bool isAdult;
  final bool appropriateContent;
  final String message;

  VerificationResponse({
    required this.verificationStatus,
    required this.humanDetected,
    required this.isAdult,
    required this.appropriateContent,
    required this.message,
  });

  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
      verificationStatus: json['verification_status'] ?? false,
      humanDetected: json['details']['human_detected'] ?? false,
      isAdult: json['details']['is_adult'] ?? false,
      appropriateContent: json['details']['appropriate_content'] ?? false,
      message: json['message'] ?? 'Verification completed',
    );
  }
}

class ImageVerificationService {
  static const String baseUrl = 'https://3ptkvm71-8000.inc1.devtunnels.ms/api';

  Future<VerificationResponse> verifyImage(File imageFile) async {
    try {
      final uri = Uri.parse('$baseUrl/verify-image/');

      var request = http.MultipartRequest('POST', uri);
      var stream = http.ByteStream(imageFile.openRead());
      var length = await imageFile.length();

      var multipartFile = http.MultipartFile(
        'profile_picture',
        stream,
        length,
        filename: 'image.jpg',
      );

      request.files.add(multipartFile);
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return VerificationResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to verify image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during image verification: $e');
    }
  }
}