// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteImpl _$$NoteImplFromJson(Map<String, dynamic> json) => _$NoteImpl(
      id: json['id'] as String,
      encryptedContent: json['encrypted_content'] as String?,
      encryptionKeyHint: json['encryption_key_hint'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      maxViews: (json['max_views'] as num).toInt(),
      currentViews: (json['current_views'] as num).toInt(),
      timeRemaining: (json['time_remaining'] as num?)?.toInt(),
      viewsRemaining: (json['views_remaining'] as num?)?.toInt(),
      isAccessible: json['is_accessible'] as bool?,
      isExpired: json['is_expired'] as bool?,
    );

Map<String, dynamic> _$$NoteImplToJson(_$NoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'encrypted_content': instance.encryptedContent,
      'encryption_key_hint': instance.encryptionKeyHint,
      'created_at': instance.createdAt.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
      'max_views': instance.maxViews,
      'current_views': instance.currentViews,
      'time_remaining': instance.timeRemaining,
      'views_remaining': instance.viewsRemaining,
      'is_accessible': instance.isAccessible,
      'is_expired': instance.isExpired,
    };

_$AIAnalysisImpl _$$AIAnalysisImplFromJson(Map<String, dynamic> json) =>
    _$AIAnalysisImpl(
      riskLevel: json['risk_level'] as String,
      maxViews: (json['max_views'] as num).toInt(),
      expiryMinutes: (json['expiry_minutes'] as num).toInt(),
      reasoning: json['reasoning'] as String,
      contentType: json['content_type'] as String,
      securityAdvice: json['security_advice'] as String,
    );

Map<String, dynamic> _$$AIAnalysisImplToJson(_$AIAnalysisImpl instance) =>
    <String, dynamic>{
      'risk_level': instance.riskLevel,
      'max_views': instance.maxViews,
      'expiry_minutes': instance.expiryMinutes,
      'reasoning': instance.reasoning,
      'content_type': instance.contentType,
      'security_advice': instance.securityAdvice,
    };

_$CreateNoteResponseImpl _$$CreateNoteResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateNoteResponseImpl(
      id: json['id'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      maxViews: (json['max_views'] as num).toInt(),
      link: json['link'] as String,
      statusLink: json['status_link'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$$CreateNoteResponseImplToJson(
        _$CreateNoteResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'expires_at': instance.expiresAt.toIso8601String(),
      'max_views': instance.maxViews,
      'link': instance.link,
      'status_link': instance.statusLink,
      'message': instance.message,
    };
