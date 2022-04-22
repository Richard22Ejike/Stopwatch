import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CountDownTimerPage extends StatefulWidget {
  static Future<void> navigatorPush(BuildContext context) async {
    return Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => CountDownTimerPage(),
      ),
    );
  }

  @override
  _State createState() => _State();
}

class _State extends State<CountDownTimerPage> {
  final _isHours = true;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromSecond(3),
    onChange: (value) => print('onChange $value'),
    onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
    onEnded: () {
      print('onEnded');
    },
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) =>
        print('rawTime $value ${StopWatchTimer.getDisplayTime(value)}'));
    _stopWatchTimer.minuteTime.listen((value) => print('minuteTime $value'));
    _stopWatchTimer.secondTime.listen((value) => print('secondTime $value'));
    _stopWatchTimer.records.listen((value) => print('records $value'));

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey[300],
          title: const Text('Stopwatch'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                /// Display stop watch time
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: StreamBuilder<int>(
                    stream: _stopWatchTimer.rawTime,
                    initialData: _stopWatchTimer.rawTime.value,
                    builder: (context, snap) {
                      final value = snap.data!;
                      final displayTime =
                      StopWatchTimer.getDisplayTime(value, hours: _isHours);
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              displayTime,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                        ],
                      );
                    },
                  ),
                ),



                /// Lap time.
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[100],
                  ),
                  height: 200,

                  margin: const EdgeInsets.all(20),
                  child: StreamBuilder<List<StopWatchRecord>>(
                    stream: _stopWatchTimer.records,
                    initialData: _stopWatchTimer.records.value,
                    builder: (context, snap) {
                      final value = snap.data!;
                      if (value.isEmpty) {
                        return Container();
                      }
                      Future.delayed(const Duration(milliseconds: 100), () {
                        _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut);
                      });
                      print('Listen records. $value');
                      return ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          final data = value[index];
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  'Lap ${index + 1}                                              ${data.displayTime}',
                                  style: const TextStyle(
                                      color: Colors.black45,
                                      fontSize: 17,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Divider(
                                height: 1,
                              )
                            ],
                          );
                        },
                        itemCount: value.length,
                      );
                    },
                  ),
                ),

                /// Button
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: RaisedButton(
                                padding: const EdgeInsets.all(4),
                                color: Colors.grey[500],
                                shape: const StadiumBorder(),
                                onPressed: () async {
                                  _stopWatchTimer.onExecute
                                      .add(StopWatchExecute.start);
                                },
                                child: const Text(
                                  'Start',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: RaisedButton(
                                padding: const EdgeInsets.all(4),
                                color: Colors.grey[500],
                                shape: const StadiumBorder(),
                                onPressed: () async {
                                  _stopWatchTimer.onExecute
                                      .add(StopWatchExecute.stop);
                                },
                                child: const Text(
                                  'Stop',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: RaisedButton(
                                padding: const EdgeInsets.all(4),
                                color: Colors.grey[500],
                                shape: const StadiumBorder(),
                                onPressed: () async {
                                  _stopWatchTimer.onExecute
                                      .add(StopWatchExecute.reset);
                                },
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(0).copyWith(right: 8),
                              child: IconButton(

                                padding: const EdgeInsets.all(4),
                                color: Colors.grey[500],

                                onPressed: () async {
                                  _stopWatchTimer.onExecute
                                      .add(StopWatchExecute.lap);
                                }, icon: Icon(Icons.flag),


                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: RaisedButton(
                                elevation: 10,
                                padding: const EdgeInsets.all(4),
                                color: Colors.grey[300],
                                shape: const StadiumBorder(),
                                onPressed: () async {
                                  _stopWatchTimer.clearPresetTime();
                                },
                                child: const Text(
                                  'Clear',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: RaisedButton(
                          elevation: 10,
                          padding: const EdgeInsets.all(4),
                          color: Colors.grey[300],
                          shape: const StadiumBorder(),
                          onPressed: () async {
                            _stopWatchTimer.setPresetTime(mSec: 380 * 1000);
                          },
                          child: const Text(
                            'Set PresetTime',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        floatingActionButton:
        Theme(
          data: Theme.of(context).copyWith(
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  extendedSizeConstraints: BoxConstraints.tightFor(height: 40,width: 90)
              )
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: (){
                      _stopWatchTimer.setPresetHoursTime(1);
                    },
                    icon: Icon(Icons.timer),
                    label: Text('Hrs'),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: (){
                      _stopWatchTimer.setPresetMinuteTime(1);
                    },
                    icon: Icon(Icons.timer),
                    label: Text('Mins'),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onPressed: (){
                      _stopWatchTimer.setPresetSecondTime(10);
                    },
                    icon: Icon(Icons.timer),
                    label: Text('Secs'),),
                ),

              ],
            ),
          ),
        )



    );
  }
}