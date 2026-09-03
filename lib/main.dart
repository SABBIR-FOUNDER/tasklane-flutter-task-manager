import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/auth_provider.dart';

import 'providers/profile_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(),
          ),

          ChangeNotifierProvider(
            create: (_) => ProfileProvider(),
          ),
        ],
        child: const TaskLaneApp(),
      )
  );
}

//Now all screen can access this auth provider. So changed.