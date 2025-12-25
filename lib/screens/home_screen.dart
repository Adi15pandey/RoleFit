import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../bloc/rolefit_bloc.dart';
import '../bloc/rolefit_event.dart';
import '../bloc/rolefit_state.dart';
import '../widgets/score_display.dart';
import '../widgets/process_flow.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _resumeController = TextEditingController();
  final TextEditingController _jdController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _resumeController.dispose();
    _jdController.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  void _handleAnalyze() {
    context.read<RoleFitBloc>().add(JobDescriptionChanged(_jdController.text));
    context.read<RoleFitBloc>().add(AnalyzeRequested());
  }

  Future<void> _pickResumePdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null && mounted) {
        final filePath = result.files.single.path!;
        final fileName = result.files.single.name;
        context.read<RoleFitBloc>().add(ResumeFileSelected(filePath, fileName: fileName));
        _resumeController.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error selecting file: ${e.toString()}')),
        );
      }
    }
  }

  void _handleReset() {
    _resumeController.clear();
    _jdController.clear();
    context.read<RoleFitBloc>().add(const ResetRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RoleFit'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<RoleFitBloc, RoleFitState>(
        listener: (context, state) {
          if (state is ResumeLoaded && state.resumeText.isNotEmpty) {
            _resumeController.text = state.resumeText;
          }
          if (state is RoleFitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AnalysisSuccess) {
            return SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ScoreDisplay(result: state.result),
                  const SizedBox(height: 24),
                  const ProcessFlow(),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleReset,
                    child: const Text('New Analysis'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Resume',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: state is! RoleFitLoading ? _pickResumePdf : null,
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Upload PDF'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (state is ResumeLoaded && state.fileName != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.description, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state.fileName!,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        TextField(
                          controller: _resumeController,
                          maxLines: 8,
                          enabled: state is! RoleFitLoading,
                          decoration: const InputDecoration(
                            hintText: 'Or paste your resume text here',
                            border: OutlineInputBorder(),
                            helperText: 'Upload your full resume. Formatting doesn\'t matter.',
                          ),
                          onChanged: (text) {
                            context.read<RoleFitBloc>().add(ResumeTextChanged(text));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Job Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _jdController,
                          maxLines: 8,
                          enabled: state is! RoleFitLoading,
                          decoration: const InputDecoration(
                            hintText: 'Paste the job description here',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (text) {
                            context.read<RoleFitBloc>().add(JobDescriptionChanged(text));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Builder(
                  builder: (context) {
                    final hasResume = (state is ResumeLoaded && state.fileName != null) ||
                        _resumeController.text.isNotEmpty;
                    final hasJobDescription = _jdController.text.isNotEmpty;
                    final canAnalyze = hasResume && hasJobDescription && state is! RoleFitLoading;

                    return ElevatedButton(
                      onPressed: canAnalyze ? _handleAnalyze : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state is RoleFitLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              'Analyze Fit',
                              style: TextStyle(fontSize: 16),
                            ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

