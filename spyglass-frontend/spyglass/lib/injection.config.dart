// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:spyglass/core/api_client.dart' as _i561;
import 'package:spyglass/domains/notes/providers/notes_provider.dart' as _i818;
import 'package:spyglass/domains/notes/repo/imp_notes_repo.dart' as _i570;
import 'package:spyglass/domains/notes/repo/notes_repo.dart' as _i237;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i561.APIClient>(() => _i561.APIClient());
    gh.lazySingleton<_i570.INoteRepository>(
        () => _i237.NoteRepository(gh<_i561.APIClient>()));
    gh.factory<_i818.NoteProvider>(
        () => _i818.NoteProvider(gh<_i570.INoteRepository>()));
    return this;
  }
}
