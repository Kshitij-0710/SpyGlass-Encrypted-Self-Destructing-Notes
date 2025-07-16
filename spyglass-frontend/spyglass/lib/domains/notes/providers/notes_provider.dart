import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:spyglass/domains/notes/models/notes.dart';
import 'package:spyglass/domains/notes/repo/imp_notes_repo.dart';
import '../../../core/enums.dart';
import '../../../core/encryption_service.dart';
import '../../../core/logger.dart';

@injectable
class NoteProvider extends ChangeNotifier {
  final INoteRepository noteRepository;

  // Current note state
  Note? _currentNote;
  CreateNoteResponse? _createResponse;
  FetchStatus _fetchStatus = FetchStatus.initial;
  SubmissionState _submissionState = SubmissionState.initial;
  String _errorMessage = '';

  // AI Analysis state
  AIAnalysis? _aiAnalysis;
  bool _isAnalyzing = false;
  List<String> _hintSuggestions = [];
  bool _isImprovingHint = false;

  // Decrypted content (temporary)
  String? _decryptedContent;

  // Getters
  Note? get currentNote => _currentNote;
  CreateNoteResponse? get createResponse => _createResponse;
  FetchStatus get fetchStatus => _fetchStatus;
  SubmissionState get submissionState => _submissionState;
  String get errorMessage => _errorMessage;
  AIAnalysis? get aiAnalysis => _aiAnalysis;
  bool get isAnalyzing => _isAnalyzing;
  List<String> get hintSuggestions => _hintSuggestions;
  bool get isImprovingHint => _isImprovingHint;
  String? get decryptedContent => _decryptedContent;

  NoteProvider(this.noteRepository);

  Future<void> createNote({
    required String content,
    required String encryptionKey,
    required String keyHint,
    required int maxViews,
    required int expiryMinutes,
  }) async {
    _submissionState = SubmissionState.submitting;
    _errorMessage = '';
    notifyListeners();

    try {
      // Encrypt content client-side
      logger.d('🔐 Encrypting content...');
      final encryptedContent = EncryptionService.encrypt(content, encryptionKey);

      final data = {
        'encrypted_content': encryptedContent,
        'encryption_key_hint': keyHint,
        'max_views': maxViews,
        'expiry_minutes': expiryMinutes,
      };

      final result = await noteRepository.createNote(data);

      result.fold(
        (error) {
          logger.e('❌ Create note error: $error');
          _errorMessage = error;
          _submissionState = SubmissionState.error;
        },
        (response) {
          logger.d('✅ Note created successfully: ${response.id}');
          _createResponse = response;
          _submissionState = SubmissionState.submitted;
        },
      );
    } catch (e) {
      logger.e('❌ Exception creating note: $e');
      _errorMessage = 'Failed to encrypt or create note: $e';
      _submissionState = SubmissionState.error;
    }

    notifyListeners();
  }

  Future<void> getNote(String id, String encryptionKey) async {
  _fetchStatus = FetchStatus.loading;
  _errorMessage = '';
  _decryptedContent = null;
  notifyListeners();

  final result = await noteRepository.getNote(id);

  result.fold(
    (error) {
      logger.e('❌ Get note error: $error');
      _errorMessage = error;
      _fetchStatus = FetchStatus.error;
    },
    (note) async {
      logger.d('✅ Note fetched successfully');
      _currentNote = note;
      
      // Check if note has encrypted content
      if (note.encryptedContent == null || note.encryptedContent!.isEmpty) {
        logger.e('❌ No encrypted content found');
        _errorMessage = 'No encrypted content available';
        _fetchStatus = FetchStatus.error;
        return;
      }
      
      // Validate encryption key
      if (encryptionKey.trim().isEmpty) {
        logger.e('❌ Empty encryption key provided');
        _errorMessage = 'Encryption key is required';
        _fetchStatus = FetchStatus.error;
        return;
      }
      
      // Log details for debugging
      logger.d('🔍 Encrypted content length: ${note.encryptedContent!.length}');
      logger.d('🔍 Encryption key length: ${encryptionKey.length}');
      
      // Try to decrypt the content with validation
      try {
        logger.d('🔓 Attempting decryption...');
        
        // Use the validation method for better error reporting
        _decryptedContent = EncryptionService.decryptWithValidation(
          note.encryptedContent!, 
          encryptionKey
        );
        
        logger.d('🔓 Content decrypted successfully: ${_decryptedContent!.length} chars');
        _fetchStatus = FetchStatus.loaded;
        
      } catch (e) {
        logger.e('❌ Decryption failed: $e');
        
        // Provide more specific error messages
        String errorMessage;
        if (e.toString().contains('Wrong encryption key')) {
          errorMessage = 'Incorrect encryption key. Please check your key and try again.';
        } else if (e.toString().contains('Invalid base64')) {
          errorMessage = 'Corrupted data - invalid format detected.';
        } else if (e.toString().contains('Data too short')) {
          errorMessage = 'Corrupted data - incomplete content.';
        } else if (e.toString().contains('Invalid encrypted data length')) {
          errorMessage = 'Corrupted data - invalid block size.';
        } else {
          errorMessage = 'Decryption failed. Please verify your encryption key.';
        }
        
        _errorMessage = errorMessage;
        _fetchStatus = FetchStatus.error;
        
        // For debugging, also test if encryption roundtrip works with this key
        if (kDebugMode) {
          logger.d('🧪 Testing encryption roundtrip with provided key...');
          final testResult = EncryptionService.testEncryptionRoundtrip('test', encryptionKey);
          logger.d('🧪 Roundtrip test result: $testResult');
        }
      }
    },
  );

  notifyListeners();
}

  

  Future<void> getNoteStatus(String id) async {
    _fetchStatus = FetchStatus.loading;
    _errorMessage = '';
    notifyListeners();

    final result = await noteRepository.getNoteStatus(id);

    result.fold(
      (error) {
        logger.e('❌ Get note status error: $error');
        _errorMessage = error;
        _fetchStatus = FetchStatus.error;
      },
      (note) {
        logger.d('✅ Note status fetched successfully');
        _currentNote = note;
        _fetchStatus = FetchStatus.loaded;
      },
    );

    notifyListeners();
  }

  Future<void> analyzeContent(String content) async {
    if (content.trim().isEmpty) return;

    _isAnalyzing = true;
    notifyListeners();

    final result = await noteRepository.analyzeContent(content);

    result.fold(
      (error) {
        logger.e('❌ AI analysis error: $error');
        _aiAnalysis = null;
      },
      (analysis) {
        logger.d('🤖 AI analysis completed: ${analysis.riskLevel}');
        _aiAnalysis = analysis;
      },
    );

    _isAnalyzing = false;
    notifyListeners();
  }

  Future<void> improveHint(String hint) async {
    if (hint.trim().isEmpty) return;

    _isImprovingHint = true;
    notifyListeners();

    final result = await noteRepository.improveHint(hint);

    result.fold(
      (error) {
        logger.e('❌ Hint improvement error: $error');
        _hintSuggestions = [];
      },
      (suggestions) {
        logger.d('💡 Hint suggestions: ${suggestions.length}');
        _hintSuggestions = suggestions;
      },
    );

    _isImprovingHint = false;
    notifyListeners();
  }

  void clearNote() {
    _currentNote = null;
    _createResponse = null;
    _decryptedContent = null;
    _fetchStatus = FetchStatus.initial;
    _submissionState = SubmissionState.initial;
    _errorMessage = '';
    notifyListeners();
  }

  void clearAIAnalysis() {
    _aiAnalysis = null;
    _hintSuggestions = [];
    notifyListeners();
  }

  void resetErrors() {
    _errorMessage = '';
    notifyListeners();
  }
}