import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:schat/app/common/common.dart';
class CallPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;

  /// Creates a call page with given channel name.
  const CallPage({Key key, this.channelName}) : super(key: key);

  @override
  _CallPageState createState() {
    return new _CallPageState();
  }
}

class _CallPageState extends State<CallPage> {
  static final _sessions = List<VideoSession>();
  bool muted = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.channelName),
        ),
        backgroundColor: Colors.black,
        body: Center(
            child: Stack(
              children: <Widget>[_viewRows(), _toolbar()],
            )));
  }
  @override
  void initState() {
    super.initState();
    initialize();
  }
  void initialize() {
    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // use _addRenderView everytime a native video view is needed
    _addRenderView(0, (viewId) {
      // local view setup & preview
      AgoraRtcEngine.setupLocalVideo(viewId, VideoRenderMode.Fit);
      AgoraRtcEngine.startPreview();
      // state can access widget directly
      AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
    });
  }
  void _addRenderView(int uid, Function(int viewId) finished) {
    Widget view = AgoraRtcEngine.createNativeView((viewId) {
      setState(() {
        _getVideoSession(uid).viewId = viewId;
        if (finished != null) {
          finished(viewId);
        }
      });
    });
    VideoSession session = VideoSession(uid, view);
    _sessions.add(session);
  }
  /// Create agora sdk instance and initialze
  void _initAgoraRtcEngine() {
    AgoraRtcEngine.create(Common.APP_ID);
    AgoraRtcEngine.enableVideo();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (int code) {
      // sdk error
    };

    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      // join channel success
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      // there's a new user joining this channel
      setState(() {
        _addRenderView(uid, (viewId) {
          AgoraRtcEngine.setupRemoteVideo(viewId, VideoRenderMode.Fit, uid);
        });
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      // there's an existing user leaving this channel
      setState(() {
        _removeRenderView(uid);
      });
    };
  }
  /// Remove a native view and remove an existing video session object
  void _removeRenderView(int uid) {
    VideoSession session = _getVideoSession(uid);
    if (session != null) {
      _sessions.remove(session);
    }
    AgoraRtcEngine.removeNativeView(session.viewId);
  }
  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    return _sessions.map((session) => session.view).toList();
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    List<Widget> wrappedViews =
    views.map((Widget view) => _videoView(view)).toList();
    return Expanded(
        child: Row(
          children: wrappedViews,
        ));
  }

  /// Video layout wrapper
  Widget _viewRows() {
    List<Widget> views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[_videoView(views[0])],
            ));
      case 2:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow([views[0]]),
                _expandedVideoRow([views[1]])
              ],
            ));
      case 3:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 3))
              ],
            ));
      case 4:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoRow(views.sublist(0, 2)),
                _expandedVideoRow(views.sublist(2, 4))
              ],
            ));
      default:
    }
    return Container();
  }
  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () => _onToggleMute(),
            child: new Icon(
              muted ? Icons.mic : Icons.mic_off,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: muted?Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: new Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: () => _onSwitchCamera(),
            child: new Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    AgoraRtcEngine.muteLocalAudioStream(muted);
  }
  VideoSession _getVideoSession(int uid) {
    return _sessions.firstWhere((session) {
      return session.uid == uid;
    });
  }
  void _onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }
  @override
  void dispose() {
    // clean up native views & destroy sdk
    _sessions.forEach((session) {
      AgoraRtcEngine.removeNativeView(session.viewId);
    });
    _sessions.clear();
    AgoraRtcEngine.destroy();
    super.dispose();
  }
}
class VideoSession {
  int uid;
  Widget view;
  int viewId;

  VideoSession(int uid, Widget view) {
    this.uid = uid;
    this.view = view;
  }
}
