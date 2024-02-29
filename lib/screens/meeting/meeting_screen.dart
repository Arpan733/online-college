import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:online_college/consts/user_shared_preferences.dart';
import 'package:online_college/providers/meeting_provider.dart';
import 'package:provider/provider.dart';

class MeetingScreen extends StatefulWidget {
  final String mid;

  const MeetingScreen({super.key, required this.mid});

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  late AgoraClient client;

  bool mute = false;
  bool screenShare = false;

  String token = '';
  String channel = '';
  String appId = '816ccbb1f55e453cb85ce1c9be33b6e0';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<MeetingProvider>(context, listen: false)
          .getMeeting(context: context, mid: widget.mid);

      if (!mounted) return;
      token = Provider.of<MeetingProvider>(context, listen: false).meeting.agoraToken;
      channel = Provider.of<MeetingProvider>(context, listen: false).meeting.channelName;

      client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: appId,
          channelName: channel,
          tempToken: token,
          uid: 0,
        ),
        agoraEventHandlers: AgoraRtcEventHandlers(
          onUserMuteAudio: (connection, remoteUid, muted) {
            mute = muted;
          },
          onUserMuteVideo: (connection, remoteUid, muted) {
            screenShare = muted;
          },
        ),
      );

      await client.initialize();
    });

    super.initState();
  }

  @override
  void dispose() {
    _onCallEnd(context);
    super.dispose();
  }

  void _onCallEnd(BuildContext context) async {
    client.release();

    if (!context.mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MeetingProvider>(
      builder: (context, meeting, child) => Scaffold(
        body: meeting.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF2855AE),
                ),
              )
            : Stack(
                children: [
                  AgoraVideoViewer(
                    client: client,
                    layoutType: Layout.floating,
                    enableHostControls: true,
                  ),
                  AgoraVideoButtons(
                    autoHideButtons: true,
                    autoHideButtonTime: 10,
                    buttonAlignment: Alignment.bottomCenter,
                    addScreenSharing: UserSharedPreferences.role == 'teacher' ? true : false,
                    onDisconnect: () => _onCallEnd(context),
                    enabledButtons: const [
                      BuiltInButtons.callEnd,
                      BuiltInButtons.switchCamera,
                      BuiltInButtons.toggleMic,
                      BuiltInButtons.screenSharing,
                    ],
                    disconnectButtonChild: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.call_end_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    muteButtonChild: GestureDetector(
                      onTap: () {
                        setState(() {
                          mute = !mute;
                        });
                        client.engine.muteLocalAudioStream(mute);
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2855AE),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            mute ? Icons.mic_off_outlined : Icons.mic_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    screenSharingButtonWidget: GestureDetector(
                      onTap: () {
                        setState(() {
                          screenShare = !screenShare;
                        });

                        client.engine.updateScreenCapture(
                          ScreenCaptureParameters2(
                            captureVideo: screenShare,
                            captureAudio: screenShare,
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2855AE),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            screenShare
                                ? Icons.stop_screen_share_outlined
                                : Icons.screen_share_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    switchCameraButtonChild: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2855AE),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.switch_camera_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    client: AgoraClient(
                      agoraConnectionData: AgoraConnectionData(
                        appId: appId,
                        channelName: channel,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 10,
                    child: IconButton(
                      onPressed: () => _onCallEnd(context),
                      icon: const Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
