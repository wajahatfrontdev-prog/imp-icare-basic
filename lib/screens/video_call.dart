// Conditional export:
//   Web  → video_call_web.dart   (Jitsi Meet External API — Flutter Web)
//   Mobile/Desktop → video_call_mobile.dart (Jitsi Meet Flutter SDK)
export 'video_call_web.dart' if (dart.library.io) 'video_call_mobile.dart';
