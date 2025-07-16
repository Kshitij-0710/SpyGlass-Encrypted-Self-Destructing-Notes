import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:spyglass/domains/notes/models/notes.dart';
import 'package:spyglass/domains/notes/repo/imp_notes_repo.dart';
import '../../../core/api_client.dart';
import '../../../core/logger.dart';
import 'dart:convert';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final APIClient apiClient;

  NoteRepository(this.apiClient);

  @override
  Future<Either<String, CreateNoteResponse>> createNote(Map<String, dynamic> data) async {
    try {
      logger.d('🚀 Creating note with data: $data');
      final response = await apiClient.post('/api/notes/', data: data);
      
      return Right(CreateNoteResponse.fromJson(response.data));
    } catch (e) {
      logger.e('❌ Error creating note: $e');
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, Note>> getNote(String id) async {
    try {
      logger.d('🔍 Fetching note: $id');
      final response = await apiClient.get('/api/notes/$id/');
      
      // Add detailed logging
      logger.d('🔍 Raw response data: ${response.data}');
      logger.d('🔍 Response data type: ${response.data.runtimeType}');
      logger.d('🔍 JSON string: ${jsonEncode(response.data)}');
      
      final note = Note.fromJson(response.data);
      logger.d('🔍 Parsed note - isAccessible: ${note.isAccessible}');
      logger.d('🔍 Parsed note - isExpired: ${note.isExpired}');
      
      return Right(note);
    } catch (e) {
      logger.e('❌ Error fetching note: $e');
      logger.e('❌ Error type: ${e.runtimeType}');
      if (e is TypeError) {
        logger.e('❌ TypeError details: $e');
      }
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, Note>> getNoteStatus(String id) async {
    try {
      logger.d('📊 Fetching note status: $id');
      final response = await apiClient.get('/api/notes/$id/status/');
      
      // Add detailed logging for status response
      logger.d('📊 Raw status response data: ${response.data}');
      logger.d('📊 Status response data type: ${response.data.runtimeType}');
      logger.d('📊 Status JSON string: ${jsonEncode(response.data)}');
      
      // Check specific fields before parsing
      final rawData = response.data as Map<String, dynamic>;
      logger.d('📊 Raw is_accessible value: ${rawData['is_accessible']}');
      logger.d('📊 Raw is_accessible type: ${rawData['is_accessible'].runtimeType}');
      logger.d('📊 Raw is_expired value: ${rawData['is_expired']}');
      logger.d('📊 Raw is_expired type: ${rawData['is_expired'].runtimeType}');
      
      final note = Note.fromJson(response.data);
      logger.d('📊 Parsed status note - isAccessible: ${note.isAccessible}');
      logger.d('📊 Parsed status note - isExpired: ${note.isExpired}');
      logger.d('📊 Parsed status note - safeIsAccessible: ${note.safeIsAccessible}');
      
      return Right(note);
    } catch (e) {
      logger.e('❌ Error fetching note status: $e');
      logger.e('❌ Error type: ${e.runtimeType}');
      if (e is TypeError) {
        logger.e('❌ TypeError details: $e');
      }
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, AIAnalysis>> analyzeContent(String content) async {
    try {
      logger.d('🤖 Analyzing content with AI');
      final response = await apiClient.post('/api/notes/ai_analyze_content/', data: {
        'content': content,
      });
      
      final aiAnalysis = response.data['ai_analysis'];
      return Right(AIAnalysis.fromJson(aiAnalysis));
    } catch (e) {
      logger.e('❌ Error analyzing content: $e');
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<String, List<String>>> improveHint(String hint) async {
    try {
      logger.d('💡 Improving hint with AI');
      final response = await apiClient.post('/api/notes/ai_improve_hint/', data: {
        'hint': hint,
      });
      
      final suggestions = List<String>.from(response.data['ai_suggestions']);
      return Right(suggestions);
    } catch (e) {
      logger.e('❌ Error improving hint: $e');
      return Left(_handleError(e));
    }
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response?.statusCode == 410) {
        return 'Note has expired or been destroyed';
      }
      if (error.response?.statusCode == 404) {
        return 'Note not found';
      }
      return error.response?.data?['error'] ?? error.message ?? 'Network error';
    }
    return error.toString();
  }
}