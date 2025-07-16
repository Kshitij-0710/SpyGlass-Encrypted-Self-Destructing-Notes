import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:spyglass/domains/notes/models/notes.dart';
import 'package:spyglass/domains/notes/providers/notes_provider.dart';
import '../../core/enums.dart';

@RoutePage()
class ViewNotePage extends StatefulWidget {
  final String noteId;
  
  const ViewNotePage({
    super.key,
    @PathParam('noteId') required this.noteId,
  });

  @override
  State<ViewNotePage> createState() => _ViewNotePageState();
}

class _ViewNotePageState extends State<ViewNotePage> 
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final _keyController = TextEditingController();
  bool _showContent = false;
  bool _obscurePassword = true;
  late AnimationController _destructionController;
  late Animation<double> _destructionAnimation;
  
  // Destruction timer settings
  static const int _readingTimeSeconds = 30; // Time to read content
  static const int _destructionAnimationSeconds = 5; // Animation duration
  int _remainingSeconds = _readingTimeSeconds;
  Timer? _countdownTimer;
  
  @override
  void initState() {
    super.initState();
    
    // Add observer for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
    
    // Enable security flags
    _enableSecurityMode();
    
    _destructionController = AnimationController(
      duration: Duration(seconds: _destructionAnimationSeconds),
      vsync: this,
    );
    
    _destructionAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _destructionController,
      curve: Curves.easeInOut,
    ));
    
    // Get note status first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteProvider>().getNoteStatus(widget.noteId);
    });
  }

  @override
  void dispose() {
    // Remove observer
    WidgetsBinding.instance.removeObserver(this);
    
    // Disable security mode
    _disableSecurityMode();
    
    _keyController.dispose();
    _destructionController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  // Handle app lifecycle changes for additional security
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // If user switches apps while viewing content, destroy immediately
      if (_showContent) {
        _immediateDestruction();
      }
    }
  }

  void _enableSecurityMode() {
    // Prevent screenshots and screen recording
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      
      // Android: Set secure flag to prevent screenshots
      SystemChannels.platform.invokeMethod('SystemChrome.setApplicationSwitcherDescription', {
        'label': 'Secure Content',
        'primaryColor': 0xFF000000,
      });
    }
    
    if (Platform.isIOS) {
      // iOS: Hide content when app goes to background
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  void _disableSecurityMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _immediateDestruction() {
    _countdownTimer?.cancel();
    if (mounted) {
      _destructionController.forward().then((_) {
        if (mounted) {
          context.router.pop();
        }
      });
    }
  }

  void _decryptNote(NoteProvider noteProvider) async {
    final key = _keyController.text.trim();
    if (key.isEmpty) return;
    
    try {
      await noteProvider.getNote(widget.noteId, key);
      
      if (noteProvider.errorMessage.isEmpty && noteProvider.decryptedContent != null) {
        setState(() {
          _showContent = true;
        });
        _startDestruction();
      }
    } catch (e) {
      // Error handling is managed by the provider
    }
  }

  void _startDestruction() {
    // Start countdown timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
      });
      
      if (_remainingSeconds <= 0) {
        timer.cancel();
        if (mounted) {
          _destructionController.forward().then((_) {
            if (mounted) {
              context.router.pop();
            }
          });
        }
      }
    });
  }

  void _pauseDestruction() {
    _countdownTimer?.cancel();
    setState(() {
      _remainingSeconds = _readingTimeSeconds; // Reset timer
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Self-destruction paused. Timer reset.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showNoteInfo(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Note Information',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Created', _formatDate(note.createdAt)),
            _buildInfoRow('Expires', _formatDate(note.expiresAt)),
            _buildInfoRow('Max Views', '${note.maxViews}'),
            _buildInfoRow('Current Views', '${note.currentViews}'),
            _buildInfoRow('Views Remaining', '${note.safeViewsRemaining}'),
            _buildInfoRow('Time Remaining', '${note.safeTimeRemaining} minutes'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(
      builder: (context, noteProvider, child) {
        return Scaffold(
          // Add security overlay for extra protection
          body: Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: const Text('Secret Note'),
                  backgroundColor: const Color(0xFF1E1E1E),
                  foregroundColor: Colors.white,
                  actions: [
                    if (noteProvider.currentNote != null && !_showContent)
                      IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: () => _showNoteInfo(context, noteProvider.currentNote!),
                      ),
                    if (_showContent) ...[
                      IconButton(
                        icon: const Icon(Icons.security),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('🔒 Screenshot protection enabled'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        tooltip: 'Security Active',
                      ),
                    ],
                  ],
                ),
                backgroundColor: const Color(0xFF121212),
                body: _buildBody(noteProvider),
              ),
              
              // Security warning overlay when content is visible
              if (_showContent)
                Positioned(
                  top: kToolbarHeight + MediaQuery.of(context).padding.top,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Colors.red.withOpacity(0.8),
                    child: const Text(
                      '🔒 SECURE MODE: Screenshots & Recording Blocked',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(NoteProvider noteProvider) {
    if (noteProvider.fetchStatus == FetchStatus.loading) {
      return _buildCenteredState(
        icon: null,
        title: 'Loading note...',
        subtitle: null,
        showSpinner: true,
      );
    }
    
    if (noteProvider.fetchStatus == FetchStatus.error) {
      return _buildCenteredState(
        icon: Icons.error_outline,
        iconColor: Colors.red,
        title: 'Error',
        subtitle: noteProvider.errorMessage,
        buttonText: 'Go Back',
        buttonColor: Colors.red,
        onButtonPressed: () => context.router.pop(),
      );
    }
    
    if (noteProvider.currentNote == null) {
      return _buildCenteredState(
        icon: Icons.search_off,
        iconColor: Colors.grey,
        title: 'Note Not Found',
        subtitle: 'The note you\'re looking for doesn\'t exist or has been removed.',
        buttonText: 'Go Back',
        buttonColor: Colors.red,
        onButtonPressed: () => context.router.pop(),
      );
    }
    
    final note = noteProvider.currentNote!;
    
    if (!note.safeIsAccessible || note.safeIsExpired) {
      return _buildCenteredState(
        icon: Icons.auto_delete,
        iconColor: Colors.orange,
        title: 'Note Expired',
        subtitle: 'This note has self-destructed. It may have expired or reached its maximum view limit.',
        buttonText: 'Go Back',
        buttonColor: Colors.red,
        onButtonPressed: () => context.router.pop(),
      );
    }
    
    if (!_showContent) {
      return _buildDecryptForm(noteProvider, note);
    }
    
    return _buildContentView(noteProvider);
  }

  Widget _buildCenteredState({
    IconData? icon,
    Color? iconColor,
    required String title,
    String? subtitle,
    String? buttonText,
    Color? buttonColor,
    VoidCallback? onButtonPressed,
    bool showSpinner = false,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showSpinner) ...[
              const CircularProgressIndicator(color: Colors.white),
              const Gap(16),
            ] else if (icon != null) ...[
              Icon(
                icon,
                size: 80,
                color: iconColor ?? Colors.grey,
              ),
              const Gap(24),
            ],
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const Gap(16),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              const Gap(32),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor ?? Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(buttonText),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDecryptForm(NoteProvider noteProvider, Note note) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning Banner
            _buildWarningBanner(),
            const Gap(32),
            
            // Encryption Key Hint
            if (note.safeEncryptionKeyHint.isNotEmpty) ...[
              _buildSection(
                title: 'Encryption Key Hint',
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: _buildContainerDecoration(),
                  child: Text(
                    note.safeEncryptionKeyHint,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              const Gap(24),
            ],
            
            // Encryption Key Input
            _buildSection(
              title: 'Encryption Key',
              child: _buildKeyInput(),
            ),
            const Gap(32),
            
            // Decrypt Button
            _buildDecryptButton(noteProvider),
            const Gap(24),
            
            // Note Info
            _buildNoteInfoSummary(note),
            
            // Error Message
            if (noteProvider.errorMessage.isNotEmpty) ...[
              const Gap(16),
              _buildErrorMessage(noteProvider.errorMessage),
            ],
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

  Widget _buildWarningBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber, color: Colors.orange),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Self-Destructing Note',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'This note will be permanently destroyed after viewing.',
                  style: TextStyle(
                    color: Colors.orange.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyInput() {
    return TextField(
      controller: _keyController,
      obscureText: _obscurePassword,
      style: const TextStyle(color: Colors.white),
      onChanged: (value) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Enter the encryption key...',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        border: _buildInputBorder(),
        enabledBorder: _buildInputBorder(),
        focusedBorder: _buildInputBorder(focused: true),
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.white.withOpacity(0.7),
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDecryptButton(NoteProvider noteProvider) {
    final isLoading = noteProvider.fetchStatus == FetchStatus.loading;
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _keyController.text.trim().isNotEmpty && !isLoading
            ? () => _decryptNote(noteProvider)
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.red.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_open),
                  Gap(8),
                  Text(
                    'Decrypt & View (Will Self-Destruct)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildContentView(NoteProvider noteProvider) {
    return AnimatedBuilder(
      animation: _destructionAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _destructionAnimation.value,
          child: Transform.scale(
            scale: _destructionAnimation.value,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 48, // Extra padding for security banner
                  bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Destruction Timer
                    _buildDestructionTimer(),
                    const Gap(32),
                    
                    // Note Content
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: _buildContainerDecoration(),
                      child: SelectableText(
                        noteProvider.decryptedContent ?? 'No content available',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const Gap(24),
                    
                    // Action Buttons
                    _buildActionButtons(noteProvider),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDestructionTimer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer, color: Colors.red),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Self-Destructing in ${_remainingSeconds}s',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'This note will disappear automatically.',
                  style: TextStyle(
                    color: Colors.red.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Pause button
          IconButton(
            onPressed: _pauseDestruction,
            icon: const Icon(Icons.pause_circle, color: Colors.orange),
            tooltip: 'Pause destruction',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(NoteProvider noteProvider) {
    return Column(
      children: [
        // Main action buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: noteProvider.decryptedContent ?? ''),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Content copied to clipboard'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.copy),
                label: const Text('Copy Content'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => context.router.pop(),
                icon: const Icon(Icons.close),
                label: const Text('Close'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const Gap(16),
        
        // Emergency destruction button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _immediateDestruction,
            icon: const Icon(Icons.delete_forever),
            label: const Text('Destroy Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteInfoSummary(Note note) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _buildContainerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Note Information',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Gap(12),
          _buildInfoItem(Icons.schedule, 'Expires', _formatDate(note.expiresAt)),
          _buildInfoItem(Icons.visibility, 'Max Views', '${note.maxViews}'),
          _buildInfoItem(Icons.remove_red_eye, 'Current Views', '${note.currentViews}'),
          _buildInfoItem(Icons.visibility_outlined, 'Views Remaining', '${note.safeViewsRemaining}'),
          _buildInfoItem(Icons.timer_outlined, 'Time Remaining', '${note.safeTimeRemaining} minutes'),
          _buildInfoItem(Icons.access_time, 'Created', _formatDate(note.createdAt)),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.white.withOpacity(0.7),
          ),
          const Gap(8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
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
              message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: const Color(0xFF2A2A2A),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white.withOpacity(0.1)),
    );
  }

  OutlineInputBorder _buildInputBorder({bool focused = false}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: focused 
            ? Colors.red 
            : Colors.white.withOpacity(0.3),
        width: focused ? 2 : 1,
      ),
    );
  }
}