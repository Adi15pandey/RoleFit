import 'package:equatable/equatable.dart';

abstract class RoleFitEvent extends Equatable {
  const RoleFitEvent();

  @override
  List<Object> get props => [];
}

class ResumeFileSelected extends RoleFitEvent {
  final String filePath;
  final String? fileName;

  const ResumeFileSelected(this.filePath, {this.fileName});

  @override
  List<Object> get props => [filePath, fileName ?? ''];
}

class ResumeTextChanged extends RoleFitEvent {
  final String text;

  const ResumeTextChanged(this.text);

  @override
  List<Object> get props => [text];
}

class JobDescriptionChanged extends RoleFitEvent {
  final String text;

  const JobDescriptionChanged(this.text);

  @override
  List<Object> get props => [text];
}

class AnalyzeRequested extends RoleFitEvent {
  const AnalyzeRequested();
}

class ResetRequested extends RoleFitEvent {
  const ResetRequested();
}

