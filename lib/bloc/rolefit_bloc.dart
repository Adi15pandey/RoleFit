import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'rolefit_event.dart';
import 'rolefit_state.dart';
import '../services/api_service.dart';

class RoleFitBloc extends Bloc<RoleFitEvent, RoleFitState> {
  final ApiService apiService;

  String resumeText = '';
  String jobDescriptionText = '';
  File? resumeFile;
  String? resumeFileName;

  RoleFitBloc({
    ApiService? apiService,
  })  : apiService = apiService ?? ApiService(),
        super(const RoleFitInitial()) {
    on<ResumeFileSelected>(_onResumeFileSelected);
    on<ResumeTextChanged>(_onResumeTextChanged);
    on<JobDescriptionChanged>(_onJobDescriptionChanged);
    on<AnalyzeRequested>(_onAnalyzeRequested);
    on<ResetRequested>(_onResetRequested);
  }

  Future<void> _onResumeFileSelected(
    ResumeFileSelected event,
    Emitter<RoleFitState> emit,
  ) async {
    try {
      emit(const RoleFitLoading());
      resumeFile = File(event.filePath);
      resumeFileName = event.fileName;
      resumeText = '';
      emit(ResumeLoaded(
        resumeText: '',
        filePath: event.filePath,
        fileName: event.fileName,
      ));
    } catch (e) {
      emit(RoleFitError('Failed to select file: ${e.toString()}'));
    }
  }

  void _onResumeTextChanged(
    ResumeTextChanged event,
    Emitter<RoleFitState> emit,
  ) {
    resumeText = event.text;
    resumeFile = null;
    resumeFileName = null;
    if (event.text.isNotEmpty) {
      emit(ResumeLoaded(resumeText: event.text));
    } else {
      emit(const RoleFitInitial());
    }
  }

  void _onJobDescriptionChanged(
    JobDescriptionChanged event,
    Emitter<RoleFitState> emit,
  ) {
    jobDescriptionText = event.text;
  }

  Future<void> _onAnalyzeRequested(
    AnalyzeRequested event,
    Emitter<RoleFitState> emit,
  ) async {
    if (jobDescriptionText.isEmpty) {
      emit(const RoleFitError('Please provide job description'));
      return;
    }

    if (resumeFile == null && resumeText.isEmpty) {
      emit(const RoleFitError('Please upload a resume PDF or paste resume text'));
      return;
    }

    emit(const RoleFitLoading());

    try {
      final result = await apiService.analyze(
        resumeFile: resumeFile,
        resumeText: resumeText.isNotEmpty ? resumeText : null,
        jobDescriptionText: jobDescriptionText,
      );

      emit(AnalysisSuccess(
        result: result,
        resumeText: resumeText,
        jobDescriptionText: jobDescriptionText,
      ));
    } catch (e) {
      emit(RoleFitError(e.toString()));
    }
  }

  void _onResetRequested(
    ResetRequested event,
    Emitter<RoleFitState> emit,
  ) {
    resumeText = '';
    jobDescriptionText = '';
    resumeFile = null;
    resumeFileName = null;
    emit(const RoleFitInitial());
  }
}

