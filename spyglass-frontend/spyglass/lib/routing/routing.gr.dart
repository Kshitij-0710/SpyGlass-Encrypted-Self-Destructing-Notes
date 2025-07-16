// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;
import 'package:spyglass/presentaion/pages/create_note_page.dart' as _i1;
import 'package:spyglass/presentaion/pages/homepage.dart' as _i2;
import 'package:spyglass/presentaion/pages/viewnotes.dart' as _i3;

abstract class $AppRouter extends _i4.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    CreateNoteRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.CreateNotePage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomePage(),
      );
    },
    ViewNoteRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ViewNoteRouteArgs>(
          orElse: () =>
              ViewNoteRouteArgs(noteId: pathParams.getString('noteId')));
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.ViewNotePage(
          key: args.key,
          noteId: args.noteId,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.CreateNotePage]
class CreateNoteRoute extends _i4.PageRouteInfo<void> {
  const CreateNoteRoute({List<_i4.PageRouteInfo>? children})
      : super(
          CreateNoteRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateNoteRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i2.HomePage]
class HomeRoute extends _i4.PageRouteInfo<void> {
  const HomeRoute({List<_i4.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i3.ViewNotePage]
class ViewNoteRoute extends _i4.PageRouteInfo<ViewNoteRouteArgs> {
  ViewNoteRoute({
    _i5.Key? key,
    required String noteId,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          ViewNoteRoute.name,
          args: ViewNoteRouteArgs(
            key: key,
            noteId: noteId,
          ),
          rawPathParams: {'noteId': noteId},
          initialChildren: children,
        );

  static const String name = 'ViewNoteRoute';

  static const _i4.PageInfo<ViewNoteRouteArgs> page =
      _i4.PageInfo<ViewNoteRouteArgs>(name);
}

class ViewNoteRouteArgs {
  const ViewNoteRouteArgs({
    this.key,
    required this.noteId,
  });

  final _i5.Key? key;

  final String noteId;

  @override
  String toString() {
    return 'ViewNoteRouteArgs{key: $key, noteId: $noteId}';
  }
}
