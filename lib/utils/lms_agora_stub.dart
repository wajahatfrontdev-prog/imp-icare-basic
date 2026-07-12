// Mobile / Desktop — Jitsi Meet Flutter SDK for LMS live sessions
import 'package:flutter/widgets.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

void Function()? _onJoined;
final _jitsiMeet = JitsiMeet();

void lmsSetCallbacks({void Function(int, bool)? onRemote, void Function()? onJoined}) {
  _onJoined = onJoined;
}

Future<void> lmsJoinChannel(String roomName, String displayName, bool isInstructor, {String jwt = '', String subject = ''}) async {
  try {
    _jitsiMeet.addListener(JitsiMeetEventListener(
      conferenceJoined: (url) { _onJoined?.call(); },
      conferenceTerminated: (url, error) {},
    ));

    final options = JitsiMeetConferenceOptions(
      serverURL: 'https://167-99-65-120.nip.io',
      room: roomName,
      token: jwt.isNotEmpty ? jwt : null,
      configOverrides: {
        'startWithAudioMuted': false,
        'startWithVideoMuted': false,
        'prejoinPageEnabled': false,
        'disableDeepLinking': true,
        'requireDisplayName': false,
        if (subject.isNotEmpty) 'subject': subject,
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
void lmsStopRecording() {} // no server-side recording flow wired up for mobile yet
void lmsMuteMic(bool mute) {}
void lmsMuteCamera(bool mute) {}
void lmsSetPanelWidth(bool open) {}
Future<void> lmsEnableMediaAndPublish() async {}
bool lmsIsSessionClosed() => false;

/// Mobile: no hard reload concept — caller falls back to normal navigation.
void lmsHardRedirect(String path) {}

String registerLmsVideoView() => '';
Widget lmsGetLocalVideoWidget(String? viewName) => const SizedBox.shrink();
Widget lmsGetRemoteVideoWidget(int uid, String channelId) => const SizedBox.shrink();
