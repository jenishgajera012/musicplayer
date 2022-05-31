import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class playsong extends StatefulWidget {
  List? currentsong;
  int aa;

  playsong(this.currentsong, this.aa);

  @override
  _playsongState createState() => _playsongState();
}

class _playsongState extends State<playsong> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool song = true;
  String? localpath;
  int dvalue = 0;
  double position = 0;
  double duration = 0;
  bool get = false;

  getsong() async {
    localpath = widget.currentsong![widget.aa].data;
    await audioPlayer.play(localpath!, isLocal: true);

    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        dvalue=d.inMilliseconds;
        get=true;
      });
    });

    audioPlayer.onDurationChanged.listen((Duration p) {
      setState(() {
        duration = p.inMilliseconds.toDouble();
      });
    });


  }

  @override
  void iniState() {
    super.initState();
    getsong();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.stop().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ListTile(
            title: Text(widget.currentsong![widget.aa].title),
          ),
          ListTile(
            title: Text(widget.currentsong![widget.aa].displayName),
          ),
          Container(
            height: 400,
            width: 300,
          ),
          Slider(
              onChanged: (value) async {
                await audioPlayer.seek(Duration(microseconds: value.toInt()));
              },
              value: position,
              max: dvalue.toDouble(),
              min: 0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () async {
                    if (widget.aa > 0) {
                      await audioPlayer.stop();
                      widget.aa = widget.aa - 1;
                      localpath = widget.currentsong![widget.aa].data;
                      await audioPlayer.play(localpath!, isLocal: true);
                    }
                    setState(() async {});
                  },
                  icon: Icon(Icons.arrow_back_ios_outlined)),
              IconButton(
                  onPressed: () async {
                    setState(() {
                      song = !song;
                    });
                    if (song) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.resume();
                    }
                    // String localpath=widget.currentsong!.data;
                    // await audioPlayer.play(localpath, isLocal: true);
                  },
                  icon: song ? Icon(Icons.play_arrow) : Icon(Icons.pause)),
              IconButton(
                  onPressed: () {
                    setState(() async {
                      if (widget.aa > 0) {
                        await audioPlayer.stop();
                        widget.aa = widget.aa + 1;
                        localpath = widget.currentsong![widget.aa];
                        await audioPlayer.play(localpath!, isLocal: true);
                      }
                      setState(() {});
                    });
                  },
                  icon: Icon(Icons.arrow_forward_ios)),
            ],
          ),
        ],
      ),
    );
  }
}
