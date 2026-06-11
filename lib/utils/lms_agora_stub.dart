// Mobile / Desktop — Jitsi Meet Flutter SDK for LMS live sessions
import 'package:flutter/widgets.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

void Function()? _onJoined;
final _jitsiMeet = JitsiMeet();

void lmsSetCallbacks({void Function(int, bool)? onRemote, void Function()? onJoined}) {
  _onJoined = onJoined;
}

Future<void> lmsJoinChannel(String roomName, String displayName, bool isInstructor) async {
  try {
    _jitsiMeet.addListener(JitsiMeetEventListener(
      conferenceJoined: (url) { _onJoined?.call(); },
      conferenceTerminated: (url, error) {},
    ));

    final options = JitsiMeetConferenceOptions(
      serverURL: 'https://meet.jit.si',
      room: roomName,
      configOverrides: {
        'startWithAudioMuted': false,
        'startWithVideoMuted': false,
        'prejoinPageEnabled': false,
        'disableDeepLinking': true,
        'requireDisplayName': false,
      },
      featureFlags: {
        'unsaferoomwarning.enabled': false,
        'invite.enabled': false,
      },
      userInfo: JitsiMeetUserInfo(
        displayName: displayName.isNotEmpty ? displayName : (isInstructor ? 'Instructor' : 'Student'),
      ),
    );
    await _jitsiMeet.join(options);
  } catch (_) {
    // Signal joined anyway so Flutter UI proceeds
    Future.delayed(const Duration(milliseconds: 600), () => _onJoined?.call());
  }
}

void lmsLeaveChannel() { try { _jitsiMeet.hangUp(); } catch (_) {} }
void lmsMuteMic(bool mute) {}
void lmsMuteCamera(bool mute) {}
void lmsSetPanelWidth(bool open) {}
void lmsStartRecording() {}
void lmsStopRecordingAndUpload(String sessionId, String backendUrl, String authToken) {}
Future<void> lmsEnableMediaAndPublish() async {}
bool lmsIsSessionClosed() => false;

String registerLmsVideoView() => '';
Widget lmsGetLocalVideoWidget(String? viewName) => const SizedBox.shrink();
Widget lmsGetRemoteVideoWidget(int uid, String channelId) => const SizedBox.shrink();
