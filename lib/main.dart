import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_size_matters/flutter_size_matters.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icare/navigators/app_router.dart';
import 'package:icare/utils/theme.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter/foundation.dart' show kIsWeb, PlatformDispatcher;
import 'package:firebase_core/firebase_core.dart';
import 'package:icare/services/fcm_service.dart';
import 'package:icare/widgets/incoming_call_listener.dart';
import 'package:icare/widgets/doctor_connect_now_listener.dart';
import 'package:icare/widgets/appointment_reminder_listener.dart';
import 'package:icare/widgets/reminder_banner_listener.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:http/http.dart' as http;
import 'package:icare/services/api_config.dart';

// Fire-and-forget: wake MongoDB before the user hits any API.
// Retries 4 times with 5s gaps — Atlas M0 can take ~20s to wake up.
void _warmUpBackend() {
  Future(() async {
    for (int i = 0; i < 4; i++) {
      try {
        final r = await http
            .get(Uri.parse('${ApiConfig.baseUrl}/ping'))
            .timeout(const Duration(seconds: 8));
        if (r.statusCode == 200) return;
      } catch (_) {}
      await Future.delayed(const Duration(seconds: 5));
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Use path-based URLs (no # hash) so /home, /login etc. work directly.
  usePathUrlStrategy();

  if (!kIsWeb) {
    await Firebase.initializeApp();
    await FcmService().init();
  }

  // Last-resort catch for any HTML-parse error that escapes interceptors.
  // Uses string matching because Dart's `is FormatException` may not work
  // correctly for errors thrown inside JavaScript promise chains on web.
  PlatformDispatcher.instance.onError = (error, stack) {
    final msg = error.toString();
    if (msg.contains('Unexpected token') ||
        msg.contains('<!doctype') ||
        msg.contains('<!DOCTYPE') ||
        msg.contains('SyntaxError')) {
      debugPrint('Suppressed cold-start HTML error: $msg');
      return true; // handled — don't crash the app
    }
    return false; // let real errors propagate
  };

  // Wake MongoDB before user interacts with any screen.
  if (kIsWeb) _warmUpBackend();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ur')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScallingConfig().init(context);
    final router = ref.watch(routerProvider);

    return ScreenUtilInit(
      designSize: const Size(1920, 1080),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'iCare Virtual Hospital',
          theme: AppTheme.mainTheme,
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            ScallingConfig().init(context);
            return FlutterSmartDialog.init()(
              context,
              IncomingCallListener(
                child: DoctorConnectNowListener(
                  child: ReminderBannerListener(
                  child: AppointmentReminderListener(
                    child: ResponsiveBreakpoints.builder(
                      child: child ?? const SizedBox(),
                      breakpoints: const [
                        Breakpoint(start: 0, end: 600, name: MOBILE),
                        Breakpoint(start: 600, end: 900, name: TABLET),
                        Breakpoint(start: 901, end: 1920, name: DESKTOP),
                        Breakpoint(start: 1921, end: double.infinity, name: '4K'),
                      ],
                    ),
                  ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
