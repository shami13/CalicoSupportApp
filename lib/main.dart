import 'dart:math';

import 'package:calico_support_app/cat_widget.dart';
import 'package:calico_support_app/model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CalicoSupportApp());
}

class CalicoSupportApp extends StatelessWidget {
  const CalicoSupportApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calico Support App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(title: 'Calico Support App'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final catsString = await rootBundle.loadString("assets/cats.yaml");
      final catsMap = loadYaml(catsString);
      processCats(catsMap);
      _randomize();
    });
  }

  void processCats(Map catsMap) {
    for (var catMap in catsMap["cats"]) {
      var cat = Cat(catMap["complexityLevel"], catMap["name"]);
      _cats.add(cat);
      if (!_catsMap.containsKey(cat.complexityLevel)) {
        _catsMap[cat.complexityLevel] = [];
      }
      _catsMap[cat.complexityLevel]!.add(cat);
    }
  }

  final List<Cat> _cats = [];
  final Map<int, List<Cat>> _catsMap = {};
  final List<Cat> _catsToShow = [];
  final List<int> _tiles = [1, 2, 3, 4, 5, 6];
  bool _volumeOn = true;

  void _randomize() {
    setState(() {
      var rng = Random();
      _catsToShow.clear();
      for (var key in _catsMap.keys) {
        _catsToShow.add(_catsMap[key]![rng.nextInt(_catsMap[key]!.length)]);
      }
      _tiles.shuffle(rng);
    });
  }

  void _changeVolumeState() {
    setState(() {
      _volumeOn = !_volumeOn;
    });
  }

  Icon _getVolumeIcon() {
    return Icon(_volumeOn ? Icons.volume_up : Icons.volume_off);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    var isPortrait = MediaQuery
        .of(context)
        .orientation == Orientation.portrait;

    double width = isPortrait ? size.width : size.width / _catsToShow.length;
    if (width > 642) {
      width = 642;
    }
    double height = width * 0.928;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: ListView.builder(
              itemCount: _catsToShow.length,
              scrollDirection: isPortrait ? Axis.vertical : Axis.horizontal,
              padding: const EdgeInsets.all(0),
              physics: isPortrait
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              dragStartBehavior: DragStartBehavior.start,
              itemBuilder: (BuildContext context, int index) {
                return Center(child: SizedBox(
                    height: height,
                    width: width,

                    child: CatWidget(
                        height: height,
                        width: width,
                        catName: _catsToShow[index].name,
                        leftTileNumber: _tiles[index * 2],
                        rightTileNumber: _tiles[index * 2 + 1])));
              },
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              // FloatingActionButton(
              //   onPressed: _changeVolumeState,
              //   tooltip: 'Purr',
              //   child: _getVolumeIcon(),
              // ),
              FloatingActionButton(
                onPressed: _randomize,
                tooltip: 'Regenerate',
                child: const Icon(Icons.refresh),
              )
            ]) // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
