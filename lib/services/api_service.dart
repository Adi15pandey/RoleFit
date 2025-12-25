import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/analysis_result.dart';

class ApiService {
  final String baseUrl;

  ApiService({String? baseUrl})
      : baseUrl = baseUrl ??
            (kIsWeb
                ? 'http://localhost:3000'
                : 'http://10.0.2.2:3000');

  Future<AnalysisResult> analyze({
    String? resumeText,
    File? resumeFile,
    required String jobDescriptionText,
  }) async {
    try {
      if (resumeFile != null) {
        return await _analyzeWithFile(resumeFile, jobDescriptionText);
      } else if (resumeText != null) {
        return await _analyzeWithText(resumeText, jobDescriptionText);
      } else {
        throw Exception('Either resume file or resume text is required');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<AnalysisResult> _analyzeWithFile(
    File resumeFile,
    String jobDescriptionText,
  ) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/analyze'),
      );

      request.files.add(
        await http.MultipartFile.fromPath('resume', resumeFile.path),
      );

      request.fields['jdText'] = jobDescriptionText;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return AnalysisResult.fromJson(data);
      } else {
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(error['error'] ?? 'Failed to analyze');
      }
    } catch (e) {
      throw Exception('Failed to upload and analyze: ${e.toString()}');
    }
  }

  Future<AnalysisResult> _analyzeWithText(
    String resumeText,
    String jobDescriptionText,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'resumeText': resumeText,
          'jdText': jobDescriptionText,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return AnalysisResult.fromJson(data);
      } else {
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        throw Exception(error['error'] ?? 'Failed to analyze');
      }
    } catch (e) {
      throw Exception('Failed to analyze: ${e.toString()}');
    }
  }
}
