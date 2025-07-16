import 'package:flutter/material.dart';
import 'package:spyglass/domains/notes/models/notes.dart';

class AIAnalysisCard extends StatelessWidget {
  final AIAnalysis? analysis;
  final bool isLoading;
  final Function(int maxViews, int expiryMinutes)? onApplySettings;

  const AIAnalysisCard({
    Key? key,
    this.analysis,
    required this.isLoading,
    this.onApplySettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            const SizedBox(height: 16),

            // Content based on state
            if (isLoading && analysis == null) 
              _buildLoadingContent()
            else if (analysis != null) 
              _buildAnalysisContent(context)
            else 
              _buildEmptyState(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.psychology,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
        const SizedBox(width: 8),
        Text(
          'AI Security Analysis',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        if (isLoading)
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      ],
    );
  }

  Widget _buildLoadingContent() {
    return Column(
      children: [
        const Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'Analyzing content for security risks and generating recommendations...',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
        ),
      ],
    );
  }

  Widget _buildAnalysisContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Risk Level Badge
        _buildRiskLevelBadge(),
        const SizedBox(height: 16),

        // Content Type
        _buildInfoSection(
          context,
          'Content Type',
          Icons.category,
          analysis!.contentType,
        ),
        const SizedBox(height: 16),

        // Security Advice
        _buildInfoSection(
          context,
          'Security Advice',
          Icons.security,
          analysis!.securityAdvice,
        ),
        const SizedBox(height: 16),

        // Reasoning
        _buildInfoSection(
          context,
          'Analysis Reasoning',
          Icons.psychology,
          analysis!.reasoning,
        ),
        const SizedBox(height: 16),

        // Recommended Settings
        _buildRecommendedSettings(context),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 48,
            color: Colors.grey,
          ),
          SizedBox(height: 8),
          Text(
            'Start typing to get AI-powered security analysis',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskLevelBadge() {
    final riskLevel = analysis!.riskLevel.toLowerCase();
    
    Color badgeColor;
    IconData icon;
    
    switch (riskLevel) {
      case 'low':
        badgeColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'medium':
        badgeColor = Colors.orange;
        icon = Icons.warning;
        break;
      case 'high':
        badgeColor = Colors.red;
        icon = Icons.error;
        break;
      default:
        badgeColor = Colors.grey;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: badgeColor, size: 18),
          const SizedBox(width: 6),
          Text(
            '${riskLevel.toUpperCase()} RISK',
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, IconData icon, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Theme.of(context).primaryColor),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedSettings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.tune, size: 18, color: Theme.of(context).primaryColor),
            const SizedBox(width: 6),
            const Text(
              'Recommended Settings',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Column(
            children: [
              _buildSettingRow(
                'Max Views',
                '${analysis!.maxViews}',
                Icons.visibility,
              ),
              const SizedBox(height: 8),
              _buildSettingRow(
                'Expiry Time',
                _formatExpiryTime(analysis!.expiryMinutes),
                Icons.timer,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onApplySettings != null
                      ? () => onApplySettings!(
                            analysis!.maxViews,
                            analysis!.expiryMinutes,
                          )
                      : null,
                  icon: const Icon(Icons.check),
                  label: const Text('Apply Recommended Settings'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.green[700]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _formatExpiryTime(int minutes) {
    if (minutes < 60) {
      return '$minutes minutes';
    } else if (minutes < 1440) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours ${hours == 1 ? 'hour' : 'hours'}';
      } else {
        return '$hours${hours == 1 ? 'h' : 'h'} ${remainingMinutes}m';
      }
    } else {
      final days = minutes ~/ 1440;
      final remainingHours = (minutes % 1440) ~/ 60;
      if (remainingHours == 0) {
        return '$days ${days == 1 ? 'day' : 'days'}';
      } else {
        return '$days${days == 1 ? 'd' : 'd'} ${remainingHours}h';
      }
    }
  }
}