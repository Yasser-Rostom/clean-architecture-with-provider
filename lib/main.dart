import 'package:clean_architecture_provider_fetching_images/features/photo_listing/presentation/pages/photo_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/photo_listing/presentation/providers/photo_provider.dart';
import 'service_locator.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setupLocator(); // Initialize the service locator
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<PhotoProvider>(),
      child: MaterialApp(
        title: 'Photo Fetcher',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const PhotoPage(),
      ),
    );
  }
}
