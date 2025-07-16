import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spyglass/domains/notes/providers/notes_provider.dart';
import 'package:spyglass/routing/routing.dart';
import 'core/logger.dart';
import 'injection.dart';

void main() {
  configureDependencies();
  
  logger.i('🚀 SpyGlass App Starting...');
  
  runApp(SpyGlassApp());
}

class SpyGlassApp extends StatelessWidget {
  final _appRouter = AppRouter();

  SpyGlassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<NoteProvider>()),
      ],
      child: MaterialApp.router(
        title: 'SpyGlass',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A1A1A),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF0A0A0A),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A1A1A),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
