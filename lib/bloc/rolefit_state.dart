import 'package:equatable/equatable.dart';
import '../models/analysis_result.dart';

abstract class RoleFitState extends Equatable {
  const RoleFitState();

  @override
  List<Object> get props => [];
}

class RoleFitInitial extends RoleFitState {
  const RoleFitInitial();
}

class RoleFitLoading extends RoleFitState {
  const RoleFitLoading();
}

class ResumeLoaded extends RoleFitState {
  final String resumeText;
  final String? filePath;
  final String? fileName;

  const ResumeLoaded({
    required this.resumeText,
    this.filePath,
    this.fileName,
  });

  @override
  List<Object> get props => [resumeText, filePath ?? '', fileName ?? ''];
}

class AnalysisSuccess extends RoleFitState {
  final AnalysisResult result;
  final String resumeText;
  final String jobDescriptionText;

  const AnalysisSuccess({
    required this.result,
    required this.resumeText,
    required this.jobDescriptionText,
  });

  @override
  List<Object> get props => [result, resumeText, jobDescriptionText];
}

class RoleFitError extends RoleFitState {
  final String message;

  const RoleFitError(this.message);

  @override
  List<Object> get props => [message];
}

