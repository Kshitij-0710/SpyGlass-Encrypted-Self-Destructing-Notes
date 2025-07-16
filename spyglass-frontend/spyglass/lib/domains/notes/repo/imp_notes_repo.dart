import 'package:dartz/dartz.dart';
import 'package:spyglass/domains/notes/models/notes.dart';

abstract class INoteRepository {
  Future<Either<String, CreateNoteResponse>> createNote(Map<String, dynamic> data);
  Future<Either<String, Note>> getNote(String id);
  Future<Either<String, Note>> getNoteStatus(String id);
  Future<Either<String, AIAnalysis>> analyzeContent(String content);
  Future<Either<String, List<String>>> improveHint(String hint);
}
