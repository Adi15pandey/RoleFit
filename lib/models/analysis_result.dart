import 'package:equatable/equatable.dart';

class AnalysisResult extends Equatable {
  final int score;
  final double similarity;
  final String message;

  const AnalysisResult({
    required this.score,
    required this.similarity,
    required this.message,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      score: json['score'] as int,
      similarity: (json['similarity'] as num).toDouble(),
      message: json['message'] as String,
    );
  }

  @override
  List<Object> get props => [score, similarity, message];
}

