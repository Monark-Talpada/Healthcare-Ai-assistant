import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

// Update the conditional import for web
import 'dart:html' if (dart.library.html) 'dart:ui' as ui;
import 'dart:js' as js;

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  RtcEngine? _engine;

  @override
  void initState() {
    super.initState();
    initializeAgora();
  }

  void registerWebViewFactory(String viewType, dynamic Function() fn) {
    // Use the new API for web view registration
    js.context.callMethod('eval', ['''
      if (!window.registeredFactories) {
        window.registeredFactories = new Set();
      }
      if (!window.registeredFactories.has("$viewType")) {
        window.registeredFactories.add("$viewType");
        (window["_flutter_web_ui_"] || window["flutterCanvasKit"]).ViewRegistry.registerViewFactory("$viewType", $fn);
      }
    ''']);
  }

  Future<void> initializeAgora() async {
    // Request permissions first
    await [Permission.microphone, Permission.camera].request();

    try {
      _engine = await createAgoraRtcEngine();
      await _engine?.initialize(const RtcEngineContext(
        appId: '4142ef1db9714b45ad481ae2e3ece2d8',
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ));

      // Register the view factory for web
      if (identical(0, 0.0)) {  // Check if running on web
        registerWebViewFactory('AgoraVideoView', () {
          return js.context['HTMLElement'].callMethod('call', [js.context['Object']]);
        });
      }

      await _engine?.enableVideo();
      await _engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      _addAgoraEventHandlers();

      // Join channel
      await _engine?.joinChannel(
        token: 'your_token_here',
        channelId: 'Healthcare',
        uid: 0,
        options: const ChannelMediaOptions(),
      );
    } catch (e) {
      print('Error initializing Agora: $e');
    }
  }

  void _addAgoraEventHandlers() {
    _engine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _infoStrings.add('onJoinChannel: ${connection.channelId}, uid: ${connection.localUid}');
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _users.add(remoteUid);
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          setState(() {
            _users.remove(remoteUid);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
      ),
      body: Center(
        child: Stack(
          children: [
            if (_engine != null)
              AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _engine!,
                  canvas: const VideoCanvas(uid: 0),
                ),
              ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FloatingActionButton(
                  onPressed: _toggleMute,
                  child: Icon(
                    muted ? Icons.mic_off : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine?.muteLocalAudioStream(muted);
  }

  @override
  void dispose() {
    _users.clear();
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }
}