import 'package:freezed_annotation/freezed_annotation.dart';

part 'notes.freezed.dart';
part 'notes.g.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required String id,
    @JsonKey(name: 'encrypted_content') String? encryptedContent, // Nullable - not in status response
    @JsonKey(name: 'encryption_key_hint') String? encryptionKeyHint, // Nullable - can be empty
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @JsonKey(name: 'max_views') required int maxViews,
    @JsonKey(name: 'current_views') required int currentViews,
    @JsonKey(name: 'time_remaining') int? timeRemaining, // Nullable - calculated field
    @JsonKey(name: 'views_remaining') int? viewsRemaining, // Nullable - calculated field
    @JsonKey(name: 'is_accessible') bool? isAccessible,
    @JsonKey(name: 'is_expired') bool? isExpired,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}

// Extension to provide safe access with defaults
extension NoteExtensions on Note {
  String get safeEncryptedContent => encryptedContent ?? '';
  String get safeEncryptionKeyHint => encryptionKeyHint ?? '';
  int get safeTimeRemaining => timeRemaining ?? 0;
  int get safeViewsRemaining => viewsRemaining ?? 0;
  bool get safeIsAccessible => isAccessible ?? false;
  bool get safeIsExpired => isExpired ?? false;
  
  // Helper to check if this note has content (came from retrieve endpoint)
  bool get hasContent => encryptedContent != null && encryptedContent!.isNotEmpty;
}

@freezed
class AIAnalysis with _$AIAnalysis {
  const factory AIAnalysis({
    @JsonKey(name: 'risk_level') required String riskLevel,
    @JsonKey(name: 'max_views') required int maxViews,
    @JsonKey(name: 'expiry_minutes') required int expiryMinutes,
    required String reasoning,
    @JsonKey(name: 'content_type') required String contentType,
    @JsonKey(name: 'security_advice') required String securityAdvice,
  }) = _AIAnalysis;

  factory AIAnalysis.fromJson(Map<String, dynamic> json) => _$AIAnalysisFromJson(json);
}

@freezed
class CreateNoteResponse with _$CreateNoteResponse {
  const factory CreateNoteResponse({
    required String id,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @JsonKey(name: 'max_views') required int maxViews,
    required String link,
    @JsonKey(name: 'status_link') required String statusLink,
    required String message,
  }) = _CreateNoteResponse;

  factory CreateNoteResponse.fromJson(Map<String, dynamic> json) => _$CreateNoteResponseFromJson(json);
}