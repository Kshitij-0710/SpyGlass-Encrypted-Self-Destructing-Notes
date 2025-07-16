// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Note _$NoteFromJson(Map<String, dynamic> json) {
  return _Note.fromJson(json);
}

/// @nodoc
mixin _$Note {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'encrypted_content')
  String? get encryptedContent =>
      throw _privateConstructorUsedError; // Nullable - not in status response
  @JsonKey(name: 'encryption_key_hint')
  String? get encryptionKeyHint =>
      throw _privateConstructorUsedError; // Nullable - can be empty
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_views')
  int get maxViews => throw _privateConstructorUsedError;
  @JsonKey(name: 'current_views')
  int get currentViews => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_remaining')
  int? get timeRemaining =>
      throw _privateConstructorUsedError; // Nullable - calculated field
  @JsonKey(name: 'views_remaining')
  int? get viewsRemaining =>
      throw _privateConstructorUsedError; // Nullable - calculated field
  @JsonKey(name: 'is_accessible')
  bool? get isAccessible => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_expired')
  bool? get isExpired => throw _privateConstructorUsedError;

  /// Serializes this Note to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteCopyWith<Note> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteCopyWith<$Res> {
  factory $NoteCopyWith(Note value, $Res Function(Note) then) =
      _$NoteCopyWithImpl<$Res, Note>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'encrypted_content') String? encryptedContent,
      @JsonKey(name: 'encryption_key_hint') String? encryptionKeyHint,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'expires_at') DateTime expiresAt,
      @JsonKey(name: 'max_views') int maxViews,
      @JsonKey(name: 'current_views') int currentViews,
      @JsonKey(name: 'time_remaining') int? timeRemaining,
      @JsonKey(name: 'views_remaining') int? viewsRemaining,
      @JsonKey(name: 'is_accessible') bool? isAccessible,
      @JsonKey(name: 'is_expired') bool? isExpired});
}

/// @nodoc
class _$NoteCopyWithImpl<$Res, $Val extends Note>
    implements $NoteCopyWith<$Res> {
  _$NoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? encryptedContent = freezed,
    Object? encryptionKeyHint = freezed,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? maxViews = null,
    Object? currentViews = null,
    Object? timeRemaining = freezed,
    Object? viewsRemaining = freezed,
    Object? isAccessible = freezed,
    Object? isExpired = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      encryptedContent: freezed == encryptedContent
          ? _value.encryptedContent
          : encryptedContent // ignore: cast_nullable_to_non_nullable
              as String?,
      encryptionKeyHint: freezed == encryptionKeyHint
          ? _value.encryptionKeyHint
          : encryptionKeyHint // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxViews: null == maxViews
          ? _value.maxViews
          : maxViews // ignore: cast_nullable_to_non_nullable
              as int,
      currentViews: null == currentViews
          ? _value.currentViews
          : currentViews // ignore: cast_nullable_to_non_nullable
              as int,
      timeRemaining: freezed == timeRemaining
          ? _value.timeRemaining
          : timeRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      viewsRemaining: freezed == viewsRemaining
          ? _value.viewsRemaining
          : viewsRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      isAccessible: freezed == isAccessible
          ? _value.isAccessible
          : isAccessible // ignore: cast_nullable_to_non_nullable
              as bool?,
      isExpired: freezed == isExpired
          ? _value.isExpired
          : isExpired // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoteImplCopyWith<$Res> implements $NoteCopyWith<$Res> {
  factory _$$NoteImplCopyWith(
          _$NoteImpl value, $Res Function(_$NoteImpl) then) =
      __$$NoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'encrypted_content') String? encryptedContent,
      @JsonKey(name: 'encryption_key_hint') String? encryptionKeyHint,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'expires_at') DateTime expiresAt,
      @JsonKey(name: 'max_views') int maxViews,
      @JsonKey(name: 'current_views') int currentViews,
      @JsonKey(name: 'time_remaining') int? timeRemaining,
      @JsonKey(name: 'views_remaining') int? viewsRemaining,
      @JsonKey(name: 'is_accessible') bool? isAccessible,
      @JsonKey(name: 'is_expired') bool? isExpired});
}

/// @nodoc
class __$$NoteImplCopyWithImpl<$Res>
    extends _$NoteCopyWithImpl<$Res, _$NoteImpl>
    implements _$$NoteImplCopyWith<$Res> {
  __$$NoteImplCopyWithImpl(_$NoteImpl _value, $Res Function(_$NoteImpl) _then)
      : super(_value, _then);

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? encryptedContent = freezed,
    Object? encryptionKeyHint = freezed,
    Object? createdAt = null,
    Object? expiresAt = null,
    Object? maxViews = null,
    Object? currentViews = null,
    Object? timeRemaining = freezed,
    Object? viewsRemaining = freezed,
    Object? isAccessible = freezed,
    Object? isExpired = freezed,
  }) {
    return _then(_$NoteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      encryptedContent: freezed == encryptedContent
          ? _value.encryptedContent
          : encryptedContent // ignore: cast_nullable_to_non_nullable
              as String?,
      encryptionKeyHint: freezed == encryptionKeyHint
          ? _value.encryptionKeyHint
          : encryptionKeyHint // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxViews: null == maxViews
          ? _value.maxViews
          : maxViews // ignore: cast_nullable_to_non_nullable
              as int,
      currentViews: null == currentViews
          ? _value.currentViews
          : currentViews // ignore: cast_nullable_to_non_nullable
              as int,
      timeRemaining: freezed == timeRemaining
          ? _value.timeRemaining
          : timeRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      viewsRemaining: freezed == viewsRemaining
          ? _value.viewsRemaining
          : viewsRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      isAccessible: freezed == isAccessible
          ? _value.isAccessible
          : isAccessible // ignore: cast_nullable_to_non_nullable
              as bool?,
      isExpired: freezed == isExpired
          ? _value.isExpired
          : isExpired // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NoteImpl implements _Note {
  const _$NoteImpl(
      {required this.id,
      @JsonKey(name: 'encrypted_content') this.encryptedContent,
      @JsonKey(name: 'encryption_key_hint') this.encryptionKeyHint,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'expires_at') required this.expiresAt,
      @JsonKey(name: 'max_views') required this.maxViews,
      @JsonKey(name: 'current_views') required this.currentViews,
      @JsonKey(name: 'time_remaining') this.timeRemaining,
      @JsonKey(name: 'views_remaining') this.viewsRemaining,
      @JsonKey(name: 'is_accessible') this.isAccessible,
      @JsonKey(name: 'is_expired') this.isExpired});

  factory _$NoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'encrypted_content')
  final String? encryptedContent;
// Nullable - not in status response
  @override
  @JsonKey(name: 'encryption_key_hint')
  final String? encryptionKeyHint;
// Nullable - can be empty
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;
  @override
  @JsonKey(name: 'max_views')
  final int maxViews;
  @override
  @JsonKey(name: 'current_views')
  final int currentViews;
  @override
  @JsonKey(name: 'time_remaining')
  final int? timeRemaining;
// Nullable - calculated field
  @override
  @JsonKey(name: 'views_remaining')
  final int? viewsRemaining;
// Nullable - calculated field
  @override
  @JsonKey(name: 'is_accessible')
  final bool? isAccessible;
  @override
  @JsonKey(name: 'is_expired')
  final bool? isExpired;

  @override
  String toString() {
    return 'Note(id: $id, encryptedContent: $encryptedContent, encryptionKeyHint: $encryptionKeyHint, createdAt: $createdAt, expiresAt: $expiresAt, maxViews: $maxViews, currentViews: $currentViews, timeRemaining: $timeRemaining, viewsRemaining: $viewsRemaining, isAccessible: $isAccessible, isExpired: $isExpired)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.encryptedContent, encryptedContent) ||
                other.encryptedContent == encryptedContent) &&
            (identical(other.encryptionKeyHint, encryptionKeyHint) ||
                other.encryptionKeyHint == encryptionKeyHint) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.maxViews, maxViews) ||
                other.maxViews == maxViews) &&
            (identical(other.currentViews, currentViews) ||
                other.currentViews == currentViews) &&
            (identical(other.timeRemaining, timeRemaining) ||
                other.timeRemaining == timeRemaining) &&
            (identical(other.viewsRemaining, viewsRemaining) ||
                other.viewsRemaining == viewsRemaining) &&
            (identical(other.isAccessible, isAccessible) ||
                other.isAccessible == isAccessible) &&
            (identical(other.isExpired, isExpired) ||
                other.isExpired == isExpired));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      encryptedContent,
      encryptionKeyHint,
      createdAt,
      expiresAt,
      maxViews,
      currentViews,
      timeRemaining,
      viewsRemaining,
      isAccessible,
      isExpired);

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
      __$$NoteImplCopyWithImpl<_$NoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteImplToJson(
      this,
    );
  }
}

abstract class _Note implements Note {
  const factory _Note(
      {required final String id,
      @JsonKey(name: 'encrypted_content') final String? encryptedContent,
      @JsonKey(name: 'encryption_key_hint') final String? encryptionKeyHint,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'expires_at') required final DateTime expiresAt,
      @JsonKey(name: 'max_views') required final int maxViews,
      @JsonKey(name: 'current_views') required final int currentViews,
      @JsonKey(name: 'time_remaining') final int? timeRemaining,
      @JsonKey(name: 'views_remaining') final int? viewsRemaining,
      @JsonKey(name: 'is_accessible') final bool? isAccessible,
      @JsonKey(name: 'is_expired') final bool? isExpired}) = _$NoteImpl;

  factory _Note.fromJson(Map<String, dynamic> json) = _$NoteImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'encrypted_content')
  String? get encryptedContent; // Nullable - not in status response
  @override
  @JsonKey(name: 'encryption_key_hint')
  String? get encryptionKeyHint; // Nullable - can be empty
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt;
  @override
  @JsonKey(name: 'max_views')
  int get maxViews;
  @override
  @JsonKey(name: 'current_views')
  int get currentViews;
  @override
  @JsonKey(name: 'time_remaining')
  int? get timeRemaining; // Nullable - calculated field
  @override
  @JsonKey(name: 'views_remaining')
  int? get viewsRemaining; // Nullable - calculated field
  @override
  @JsonKey(name: 'is_accessible')
  bool? get isAccessible;
  @override
  @JsonKey(name: 'is_expired')
  bool? get isExpired;

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AIAnalysis _$AIAnalysisFromJson(Map<String, dynamic> json) {
  return _AIAnalysis.fromJson(json);
}

/// @nodoc
mixin _$AIAnalysis {
  @JsonKey(name: 'risk_level')
  String get riskLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_views')
  int get maxViews => throw _privateConstructorUsedError;
  @JsonKey(name: 'expiry_minutes')
  int get expiryMinutes => throw _privateConstructorUsedError;
  String get reasoning => throw _privateConstructorUsedError;
  @JsonKey(name: 'content_type')
  String get contentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'security_advice')
  String get securityAdvice => throw _privateConstructorUsedError;

  /// Serializes this AIAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIAnalysisCopyWith<AIAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIAnalysisCopyWith<$Res> {
  factory $AIAnalysisCopyWith(
          AIAnalysis value, $Res Function(AIAnalysis) then) =
      _$AIAnalysisCopyWithImpl<$Res, AIAnalysis>;
  @useResult
  $Res call(
      {@JsonKey(name: 'risk_level') String riskLevel,
      @JsonKey(name: 'max_views') int maxViews,
      @JsonKey(name: 'expiry_minutes') int expiryMinutes,
      String reasoning,
      @JsonKey(name: 'content_type') String contentType,
      @JsonKey(name: 'security_advice') String securityAdvice});
}

/// @nodoc
class _$AIAnalysisCopyWithImpl<$Res, $Val extends AIAnalysis>
    implements $AIAnalysisCopyWith<$Res> {
  _$AIAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? riskLevel = null,
    Object? maxViews = null,
    Object? expiryMinutes = null,
    Object? reasoning = null,
    Object? contentType = null,
    Object? securityAdvice = null,
  }) {
    return _then(_value.copyWith(
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as String,
      maxViews: null == maxViews
          ? _value.maxViews
          : maxViews // ignore: cast_nullable_to_non_nullable
              as int,
      expiryMinutes: null == expiryMinutes
          ? _value.expiryMinutes
          : expiryMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      reasoning: null == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      securityAdvice: null == securityAdvice
          ? _value.securityAdvice
          : securityAdvice // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIAnalysisImplCopyWith<$Res>
    implements $AIAnalysisCopyWith<$Res> {
  factory _$$AIAnalysisImplCopyWith(
          _$AIAnalysisImpl value, $Res Function(_$AIAnalysisImpl) then) =
      __$$AIAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'risk_level') String riskLevel,
      @JsonKey(name: 'max_views') int maxViews,
      @JsonKey(name: 'expiry_minutes') int expiryMinutes,
      String reasoning,
      @JsonKey(name: 'content_type') String contentType,
      @JsonKey(name: 'security_advice') String securityAdvice});
}

/// @nodoc
class __$$AIAnalysisImplCopyWithImpl<$Res>
    extends _$AIAnalysisCopyWithImpl<$Res, _$AIAnalysisImpl>
    implements _$$AIAnalysisImplCopyWith<$Res> {
  __$$AIAnalysisImplCopyWithImpl(
      _$AIAnalysisImpl _value, $Res Function(_$AIAnalysisImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? riskLevel = null,
    Object? maxViews = null,
    Object? expiryMinutes = null,
    Object? reasoning = null,
    Object? contentType = null,
    Object? securityAdvice = null,
  }) {
    return _then(_$AIAnalysisImpl(
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as String,
      maxViews: null == maxViews
          ? _value.maxViews
          : maxViews // ignore: cast_nullable_to_non_nullable
              as int,
      expiryMinutes: null == expiryMinutes
          ? _value.expiryMinutes
          : expiryMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      reasoning: null == reasoning
          ? _value.reasoning
          : reasoning // ignore: cast_nullable_to_non_nullable
              as String,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      securityAdvice: null == securityAdvice
          ? _value.securityAdvice
          : securityAdvice // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIAnalysisImpl implements _AIAnalysis {
  const _$AIAnalysisImpl(
      {@JsonKey(name: 'risk_level') required this.riskLevel,
      @JsonKey(name: 'max_views') required this.maxViews,
      @JsonKey(name: 'expiry_minutes') required this.expiryMinutes,
      required this.reasoning,
      @JsonKey(name: 'content_type') required this.contentType,
      @JsonKey(name: 'security_advice') required this.securityAdvice});

  factory _$AIAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIAnalysisImplFromJson(json);

  @override
  @JsonKey(name: 'risk_level')
  final String riskLevel;
  @override
  @JsonKey(name: 'max_views')
  final int maxViews;
  @override
  @JsonKey(name: 'expiry_minutes')
  final int expiryMinutes;
  @override
  final String reasoning;
  @override
  @JsonKey(name: 'content_type')
  final String contentType;
  @override
  @JsonKey(name: 'security_advice')
  final String securityAdvice;

  @override
  String toString() {
    return 'AIAnalysis(riskLevel: $riskLevel, maxViews: $maxViews, expiryMinutes: $expiryMinutes, reasoning: $reasoning, contentType: $contentType, securityAdvice: $securityAdvice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIAnalysisImpl &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            (identical(other.maxViews, maxViews) ||
                other.maxViews == maxViews) &&
            (identical(other.expiryMinutes, expiryMinutes) ||
                other.expiryMinutes == expiryMinutes) &&
            (identical(other.reasoning, reasoning) ||
                other.reasoning == reasoning) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.securityAdvice, securityAdvice) ||
                other.securityAdvice == securityAdvice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, riskLevel, maxViews,
      expiryMinutes, reasoning, contentType, securityAdvice);

  /// Create a copy of AIAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIAnalysisImplCopyWith<_$AIAnalysisImpl> get copyWith =>
      __$$AIAnalysisImplCopyWithImpl<_$AIAnalysisImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIAnalysisImplToJson(
      this,
    );
  }
}

abstract class _AIAnalysis implements AIAnalysis {
  const factory _AIAnalysis(
      {@JsonKey(name: 'risk_level') required final String riskLevel,
      @JsonKey(name: 'max_views') required final int maxViews,
      @JsonKey(name: 'expiry_minutes') required final int expiryMinutes,
      required final String reasoning,
      @JsonKey(name: 'content_type') required final String contentType,
      @JsonKey(name: 'security_advice')
      required final String securityAdvice}) = _$AIAnalysisImpl;

  factory _AIAnalysis.fromJson(Map<String, dynamic> json) =
      _$AIAnalysisImpl.fromJson;

  @override
  @JsonKey(name: 'risk_level')
  String get riskLevel;
  @override
  @JsonKey(name: 'max_views')
  int get maxViews;
  @override
  @JsonKey(name: 'expiry_minutes')
  int get expiryMinutes;
  @override
  String get reasoning;
  @override
  @JsonKey(name: 'content_type')
  String get contentType;
  @override
  @JsonKey(name: 'security_advice')
  String get securityAdvice;

  /// Create a copy of AIAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIAnalysisImplCopyWith<_$AIAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateNoteResponse _$CreateNoteResponseFromJson(Map<String, dynamic> json) {
  return _CreateNoteResponse.fromJson(json);
}

/// @nodoc
mixin _$CreateNoteResponse {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_views')
  int get maxViews => throw _privateConstructorUsedError;
  String get link => throw _privateConstructorUsedError;
  @JsonKey(name: 'status_link')
  String get statusLink => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this CreateNoteResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateNoteResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateNoteResponseCopyWith<CreateNoteResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateNoteResponseCopyWith<$Res> {
  factory $CreateNoteResponseCopyWith(
          CreateNoteResponse value, $Res Function(CreateNoteResponse) then) =
      _$CreateNoteResponseCopyWithImpl<$Res, CreateNoteResponse>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'expires_at') DateTime expiresAt,
      @JsonKey(name: 'max_views') int maxViews,
      String link,
      @JsonKey(name: 'status_link') String statusLink,
      String message});
}

/// @nodoc
class _$CreateNoteResponseCopyWithImpl<$Res, $Val extends CreateNoteResponse>
    implements $CreateNoteResponseCopyWith<$Res> {
  _$CreateNoteResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateNoteResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expiresAt = null,
    Object? maxViews = null,
    Object? link = null,
    Object? statusLink = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxViews: null == maxViews
          ? _value.maxViews
          : maxViews // ignore: cast_nullable_to_non_nullable
              as int,
      link: null == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      statusLink: null == statusLink
          ? _value.statusLink
          : statusLink // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateNoteResponseImplCopyWith<$Res>
    implements $CreateNoteResponseCopyWith<$Res> {
  factory _$$CreateNoteResponseImplCopyWith(_$CreateNoteResponseImpl value,
          $Res Function(_$CreateNoteResponseImpl) then) =
      __$$CreateNoteResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'expires_at') DateTime expiresAt,
      @JsonKey(name: 'max_views') int maxViews,
      String link,
      @JsonKey(name: 'status_link') String statusLink,
      String message});
}

/// @nodoc
class __$$CreateNoteResponseImplCopyWithImpl<$Res>
    extends _$CreateNoteResponseCopyWithImpl<$Res, _$CreateNoteResponseImpl>
    implements _$$CreateNoteResponseImplCopyWith<$Res> {
  __$$CreateNoteResponseImplCopyWithImpl(_$CreateNoteResponseImpl _value,
      $Res Function(_$CreateNoteResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateNoteResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expiresAt = null,
    Object? maxViews = null,
    Object? link = null,
    Object? statusLink = null,
    Object? message = null,
  }) {
    return _then(_$CreateNoteResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxViews: null == maxViews
          ? _value.maxViews
          : maxViews // ignore: cast_nullable_to_non_nullable
              as int,
      link: null == link
          ? _value.link
          : link // ignore: cast_nullable_to_non_nullable
              as String,
      statusLink: null == statusLink
          ? _value.statusLink
          : statusLink // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateNoteResponseImpl implements _CreateNoteResponse {
  const _$CreateNoteResponseImpl(
      {required this.id,
      @JsonKey(name: 'expires_at') required this.expiresAt,
      @JsonKey(name: 'max_views') required this.maxViews,
      required this.link,
      @JsonKey(name: 'status_link') required this.statusLink,
      required this.message});

  factory _$CreateNoteResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateNoteResponseImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'expires_at')
  final DateTime expiresAt;
  @override
  @JsonKey(name: 'max_views')
  final int maxViews;
  @override
  final String link;
  @override
  @JsonKey(name: 'status_link')
  final String statusLink;
  @override
  final String message;

  @override
  String toString() {
    return 'CreateNoteResponse(id: $id, expiresAt: $expiresAt, maxViews: $maxViews, link: $link, statusLink: $statusLink, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateNoteResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.maxViews, maxViews) ||
                other.maxViews == maxViews) &&
            (identical(other.link, link) || other.link == link) &&
            (identical(other.statusLink, statusLink) ||
                other.statusLink == statusLink) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, expiresAt, maxViews, link, statusLink, message);

  /// Create a copy of CreateNoteResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateNoteResponseImplCopyWith<_$CreateNoteResponseImpl> get copyWith =>
      __$$CreateNoteResponseImplCopyWithImpl<_$CreateNoteResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateNoteResponseImplToJson(
      this,
    );
  }
}

abstract class _CreateNoteResponse implements CreateNoteResponse {
  const factory _CreateNoteResponse(
      {required final String id,
      @JsonKey(name: 'expires_at') required final DateTime expiresAt,
      @JsonKey(name: 'max_views') required final int maxViews,
      required final String link,
      @JsonKey(name: 'status_link') required final String statusLink,
      required final String message}) = _$CreateNoteResponseImpl;

  factory _CreateNoteResponse.fromJson(Map<String, dynamic> json) =
      _$CreateNoteResponseImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'expires_at')
  DateTime get expiresAt;
  @override
  @JsonKey(name: 'max_views')
  int get maxViews;
  @override
  String get link;
  @override
  @JsonKey(name: 'status_link')
  String get statusLink;
  @override
  String get message;

  /// Create a copy of CreateNoteResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateNoteResponseImplCopyWith<_$CreateNoteResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
