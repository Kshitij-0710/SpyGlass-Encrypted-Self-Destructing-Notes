import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:spyglass/domains/notes/providers/notes_provider.dart';
import 'package:spyglass/presentaion/widgets/ai_card.dart';
import 'package:spyglass/presentaion/widgets/encryption_form.dart';
import '../../core/enums.dart';


@RoutePage()
class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final _contentController = TextEditingController();
  final _keyController = TextEditingController();
  final _hintController = TextEditingController();
  
  int _maxViews = 1;
  int _expiryMinutes = 60;
  
  @override
  void dispose() {
    _contentController.dispose();
    _keyController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Secret Note'),
            actions: [
              if (noteProvider.submissionState == SubmissionState.submitted)
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    noteProvider.clearNote();
                    _clearForm();
                  },
                ),
            ],
          ),
          body: noteProvider.submissionState == SubmissionState.submitted
              ? _buildSuccessView(noteProvider)
              : _buildCreateForm(noteProvider),
        );
      },
    );
  }

  Widget _buildCreateForm(NoteProvider noteProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content Input
          _buildSection(
            title: 'Secret Message',
            child: TextField(
              controller: _contentController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your secret message...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                border: _buildInputBorder(),
                enabledBorder: _buildInputBorder(),
                focusedBorder: _buildInputBorder(focused: true),
                filled: true,
                fillColor: const Color(0xFF2A2A2A),
              ),
              onChanged: (text) {
                // Trigger AI analysis with debouncing
                if (text.trim().isNotEmpty) {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    if (_contentController.text.trim() == text.trim()) {
                      noteProvider.analyzeContent(text);
                    }
                  });
                }
              },
            ),
          ),
          
          const Gap(24),
          
          // AI Analysis Card
          if (noteProvider.isAnalyzing || noteProvider.aiAnalysis != null)
            AIAnalysisCard(
              analysis: noteProvider.aiAnalysis,
              isLoading: noteProvider.isAnalyzing,
              onApplySettings: (maxViews, expiryMinutes) {
                setState(() {
                  _maxViews = maxViews;
                  _expiryMinutes = expiryMinutes;
                });
              },
            ),
          
          const Gap(24),
          
          // Encryption Settings
          EncryptionForm(
            keyController: _keyController,
            hintController: _hintController,
            maxViews: _maxViews,
            expiryMinutes: _expiryMinutes,
            onMaxViewsChanged: (value) => setState(() => _maxViews = value),
            onExpiryChanged: (value) => setState(() => _expiryMinutes = value),
            hintSuggestions: noteProvider.hintSuggestions,
            isImprovingHint: noteProvider.isImprovingHint,
            onImproveHint: (hint) => noteProvider.improveHint(hint),
            onHintSuggestionSelected: (suggestion) {
              _hintController.text = suggestion;
            },
          ),
          
          const Gap(32),
          
          // Create Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _canCreateNote(noteProvider) ? () => _createNote(noteProvider) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                disabledBackgroundColor: Colors.white.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: noteProvider.submissionState == SubmissionState.submitting
                  ? const CircularProgressIndicator(color: Colors.black)
                  : const Text(
                      'Create Encrypted Note',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          
          // Error Message
          if (noteProvider.errorMessage.isNotEmpty) ...[
            const Gap(16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const Gap(8),
                  Expanded(
                    child: Text(
                      noteProvider.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSuccessView(NoteProvider noteProvider) {
    final response = noteProvider.createResponse!;
    final shareUrl = 'https://spyglass.app/note/${response.id}';
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Success Header
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 40,
              ),
            ),
            
            const Gap(24),
            
            const Text(
              'Note Created Successfully!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            
            const Gap(32),
            
            // QR Code
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: QrImageView(
                data: shareUrl,
                version: QrVersions.auto,
                size: 200,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
            
            const Gap(24),
            
            // Share Options
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _copyToClipboard(shareUrl),
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Link'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A2A2A),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _shareNote(shareUrl),
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _copyToClipboard(response.id, isId: true),
                    icon: const Icon(Icons.vpn_key),
                    label: const Text('Copy ID'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            
            const Gap(24),
            
            // Note Info
            _buildInfoCard('Note Details', [
              'ID: ${response.id}',
              'Max Views: ${response.maxViews}',
              'Expires: ${_formatExpiryTime(response.expiresAt)}',
            ]),
            
            const SizedBox(height: 32),
            
            // Warning
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.orange),
                  const Gap(12),
                  const Expanded(
                    child: Text(
                      'Share the encryption key separately! The note will self-destruct after viewing.',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Gap(12),
        child,
      ],
    );
  }

  Widget _buildInfoCard(String title, List<String> items) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Gap(8),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          )),
        ],
      ),
    );
  }

  OutlineInputBorder _buildInputBorder({bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: focused ? Colors.white : Colors.white.withOpacity(0.3),
        width: focused ? 2 : 1,
      ),
    );
  }

  // FIXED: Made hint optional - button works regardless of hint input
  bool _canCreateNote(NoteProvider noteProvider) {
    return _contentController.text.trim().isNotEmpty &&
           _keyController.text.trim().isNotEmpty &&
           noteProvider.submissionState != SubmissionState.submitting;
  }

  // FIXED: Handle empty hint by providing a default value
  void _createNote(NoteProvider noteProvider) {
    final hint = _hintController.text.trim().isEmpty 
        ? 'No hint provided' 
        : _hintController.text.trim();
        
    noteProvider.createNote(
      content: _contentController.text.trim(),
      encryptionKey: _keyController.text.trim(),
      keyHint: hint,
      maxViews: _maxViews,
      expiryMinutes: _expiryMinutes,
    );
  }

  void _clearForm() {
    _contentController.clear();
    _keyController.clear();
    _hintController.clear();
    setState(() {
      _maxViews = 1;
      _expiryMinutes = 60;
    });
  }

  void _copyToClipboard(String text, {bool isId = false}) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isId ? 'ID copied to clipboard!' : 'Link copied to clipboard!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _shareNote(String url) {
    // Implement share functionality
    // Share.share(url);
  }

  String _formatExpiryTime(DateTime expiry) {
    final now = DateTime.now();
    final diff = expiry.difference(now);
    
    if (diff.inHours > 24) {
      return '${diff.inDays} days';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hours';
    } else {
      return '${diff.inMinutes} minutes';
    }
  }
}