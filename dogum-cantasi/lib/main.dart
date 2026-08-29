import 'package:flutter/material.dart';

import 'screens/bag_list_screen.dart';
import 'services/notification_service.dart';
import 'theme/design_tokens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.init();
  runApp(const DogumCantasiApp());
}

class DogumCantasiApp extends StatelessWidget {
  const DogumCantasiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doğum Çantası',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const BagListScreen(),
    );
  }
}
