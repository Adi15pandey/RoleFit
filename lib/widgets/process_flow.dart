import 'package:flutter/material.dart';

class ProcessFlow extends StatelessWidget {
  const ProcessFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analysis Process',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildFlowStep('Resume Text', Icons.description, 0),
            _buildArrow(),
            _buildFlowStep('Text Cleaning', Icons.cleaning_services, 1),
            _buildArrow(),
            _buildFlowStep('Embedding Generation\n(HuggingFace)', Icons.psychology, 2),
            _buildArrow(),
            _buildFlowStep('JD Embedding', Icons.work, 3),
            _buildArrow(),
            _buildFlowStep('Cosine Similarity', Icons.calculate, 4),
            _buildArrow(),
            _buildFlowStep('Match Score (%)', Icons.percent, 5, isLast: true),
          ],
        ),
      ),
    );
  }

  Widget _buildFlowStep(String label, IconData icon, int index, {bool isLast = false}) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.withValues(alpha: 0.1),
            border: Border.all(color: Colors.blue, width: 2),
          ),
          child: Icon(icon, color: Colors.blue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildArrow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const SizedBox(width: 40),
          const SizedBox(width: 12),
          Icon(Icons.arrow_downward, size: 20, color: Colors.grey[600]),
        ],
      ),
    );
  }
}

