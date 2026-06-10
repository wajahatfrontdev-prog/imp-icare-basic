// Mobile / Desktop video call — Jitsi Meet Flutter SDK
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/call_service.dart';
import '../utils/shared_pref.dart';
import '../utils/theme.dart';

class VideoCall extends StatefulWidget {
  final String channelName;
  final String remoteUserName;
  final bool isAudioOnly;
  final String currentUserId;
  final String currentUserName;
  final String? appointmentId;
  final String? patientId;
  final String? consultationId;
  final int consultationElapsedSeconds;
  final String? outgoingSignalId;
  final VoidCallback? onCallEnded;

  const VideoCall({
    super.key,
    required this.channelName,
    required this.remoteUserName,
    this.isAudioOnly = false,
    this.currentUserId = '',
    this.currentUserName = 'User',
    this.appointmentId,
    this.patientId,
    this.consultationId,
    this.consultationElapsedSeconds = 0,
    this.outgoingSignalId,
    this.onCallEnded,
  });

  @override
  State<VideoCall> createState() => _VideoCallMobileState();
}

class _VideoCallMobileState extends State<VideoCall> {
  bool _loading = true;
  bool _remoteJoined = false;
  String? _error;
  bool _isDoctor = false;
  Timer? _noAnswerTimer;
  Timer? _declinePoller;
  Timer? _callTimer;
  int _elapsedSeconds = 0;
  final _jitsiMeet = JitsiMeet();

  @override
  void initState() {
    super.initState();
    _initRole();
    _launchJitsi();
    _startNoAnswerTimer();
  }

  Future<void> _initRole() async {
    try {
      final user = await SharedPref().getUserData();
      if (mounted) {
        setState(() => _isDoctor = user?.role.toLowerCase() == 'doctor');
        if (_isDoctor) _startDeclinePoller();
      }
    } catch (_) {}
  }

  void _startDeclinePoller() {
    if (widget.outgoingSignalId == null || widget.outgoingSignalId!.isEmpty) return;
    _declinePoller = Timer.periodic(const Duration(seconds: 2), (_) async {
      if (!mounted || _remoteJoined) { _declinePoller?.cancel(); return; }
      try {
        final status = await CallService().checkOutgoingCallStatus(widget.outgoingSignalId!);
        if (status == 'rejected' || status == 'declined') {
          _declinePoller?.cancel();
          _noAnswerTimer?.cancel();
          if (!mounted) return;
          await _jitsiMeet.hangUp();
          if (!mounted) return;
          _showDeclinedDialog();
        }
      } catch (_) { _declinePoller?.cancel(); }
    });
  }

  void _startNoAnswerTimer() {
    _noAnswerTimer = Timer(const Duration(seconds: 45), () {
      if (!mounted || _remoteJoined) return;
      _noAnswerTimer?.cancel();
      _jitsiMeet.hangUp();
      if (!mounted) return;
      final nav = Navigator.of(context);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(children: [
            Icon(Icons.call_end_rounded, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Not Answered', style: TextStyle(fontWeight: FontWeight.w800)),
          ]),
          content: const Text('The patient did not answer or declined the call.'),
          actions: [
            ElevatedButton(
              onPressed: () { nav.pop(); nav.pop(); },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: const Text('Go Back'),
            ),
          ],
        ),
      );
    });
  }

  void _showDeclinedDialog() {
    final nav = Navigator.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(children: [
          Icon(Icons.call_end_rounded, color: Colors.red, size: 26),
          SizedBox(width: 10),
          Text('Call Declined'),
        ]),
        content: const Text('The patient has declined your call.'),
        actions: [
          ElevatedButton(
            onPressed: () { nav.pop(); nav.pop(); },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  void _startCallTimer() {
    _callTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsedSeconds++);
    });
  }

  Future<void> _launchJitsi() async {
    try {
      if (!kIsWeb) {
        await Permission.camera.request();
        await Permission.microphone.request();
      }

      // Sanitize room name for Jitsi (alphanumeric, prefixed)
      final raw = widget.channelName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
      final roomName = 'icare${raw.substring(0, raw.length.clamp(0, 50))}';

      _jitsiMeet.addListener(JitsiMeetEventListener(
        conferenceWillJoin: (url) {
          if (mounted) setState(() => _loading = false);
        },
        conferenceJoined: (url) {
          if (mounted) setState(() => _loading = false);
          _startCallTimer();
        },
        participantJoined: (email, name, role, id) {
          if (mounted && !_remoteJoined) {
            setState(() => _remoteJoined = true);
            _noAnswerTimer?.cancel();
            _declinePoller?.cancel();
          }
        },
        conferenceTerminated: (url, error) {
          _callTimer?.cancel();
          if (mounted) {
            widget.onCallEnded?.call();
            Navigator.pop(context);
          }
        },
      ));

      final options = JitsiMeetConferenceOptions(
        serverURL: 'https://meet.jit.si',
        room: roomName,
        configOverrides: {
          'startWithAudioMuted': false,
          'startWithVideoMuted': widget.isAudioOnly,
          'prejoinPageEnabled': false,
          'disableDeepLinking': true,
          'requireDisplayName': false,
          'doNotStoreRoom': true,
        },
        featureFlags: {
          'unsaferoomwarning.enabled': false,
          'invite.enabled': false,
        },
        userInfo: JitsiMeetUserInfo(
          displayName: widget.currentUserName.isNotEmpty
              ? widget.currentUserName
              : 'User',
        ),
      );

      await _jitsiMeet.join(options);
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  void dispose() {
    _callTimer?.cancel();
    _noAnswerTimer?.cancel();
    _declinePoller?.cancel();
    _jitsiMeet.hangUp();
    super.dispose();
  }

  String get _timerText {
    final m = _elapsedSeconds ~/ 60;
    final s = _elapsedSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return _buildError();
    if (_loading) return _buildConnecting();
    return _buildCallActive();
  }

  Widget _buildConnecting() {
    final initial = widget.remoteUserName.isNotEmpty
        ? widget.remoteUserName[0].toUpperCase()
        : '?';
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100, height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white12,
                border: Border.all(color: Colors.blueAccent, width: 3),
              ),
              child: Center(
                child: Text(initial,
                    style: const TextStyle(
                        fontSize: 42,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.remoteUserName.isNotEmpty
                  ? widget.remoteUserName
                  : 'Connecting...',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            const Text('Launching Jitsi Meet...',
                style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 32),
            const CircularProgressIndicator(color: Colors.blueAccent),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () async {
                await _jitsiMeet.hangUp();
                if (mounted) Navigator.pop(context);
              },
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.red, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallActive() {
    // Jitsi runs in its native layer; show a thin status bar while call is open
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.black87,
              child: Row(
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.remoteUserName.isNotEmpty
                          ? widget.remoteUserName
                          : 'Call in Progress',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(_timerText,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 13)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFF0A1628),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.videocam_rounded,
                          color: Colors.white24, size: 64),
                      const SizedBox(height: 16),
                      const Text('Jitsi Meet is running',
                          style: TextStyle(
                              color: Colors.white38, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 56),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(_error ?? 'Unknown error',
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
