import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mokamayu/constants/colors.dart';
import 'package:mokamayu/services/authentication/auth.dart';
import 'package:mokamayu/services/managers/app_state_manager.dart';
import 'package:mokamayu/services/managers/profile_manager.dart';
import 'package:mokamayu/services/managers/wardrobe_manager.dart';
import 'package:mokamayu/widgets/photo_grid/photo_tapped.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';
import 'models/firebase_user.dart';
import 'navigation/app_router.dart';
import 'services/managers/outfit_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appStateManager = AppStateManager();
  await appStateManager.initializeApp();

  if (kDebugMode) {
    try {
      // do testowania na emulatorach lokalnie
      FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
      await FirebaseAuth.instance.useAuthEmulator('127.0.0.1', 9099);
    } catch (e) {
      // ignore: avoids_print
      print(e);
    }
  }
  runApp(MyApp(appStateManager: appStateManager));
}

class MyApp extends StatefulWidget {
  final AppStateManager appStateManager;

  MyApp({
    Key? key,
    required this.appStateManager,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _profileManager = ProfileManager();
  late final _wardrobeManager = WardrobeManager();
  late final _outfitManager = OutfitManager();

  late final _appRouter = AppRouter(widget.appStateManager, _profileManager,
      _wardrobeManager, _outfitManager);

  @override
  Widget build(BuildContext context) {
    final router = _appRouter.router;

    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser?>.value(
            value: AuthService().user, initialData: null),
        ChangeNotifierProvider(create: (context) => _profileManager),
        ChangeNotifierProvider(create: (context) => widget.appStateManager),
        ChangeNotifierProvider(create: (_) => WardrobeManager()),
        ChangeNotifierProvider(create: (_) => OutfitManager()),
        ChangeNotifierProvider(create: (_) => PhotoTapped()),
      ],
      child: MaterialApp.router(
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        title: 'Mokamayu',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: ColorsConstants.darkBrick),
        ),
      ),
    );
  }
}
