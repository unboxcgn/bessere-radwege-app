import 'package:bessereradwege/view/settings_pane.dart';
import 'package:bessereradwege/view/no_rides_pane.dart';
import 'package:bessereradwege/view/rides_pane.dart';
import 'package:bessereradwege/view/info_pane.dart';
import 'package:bessereradwege/view/record_screen.dart';
import 'package:bessereradwege/model/ride.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});

  final String title;

  @override
  State<MainScreen> createState() {
    return _MainScreenState();
  }
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  void _setPageIndex(int idx) {
    if (_pageIndex != idx) {
      setState(() {
        _pageIndex = idx;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    bool haveCurrentRide = (Provider.of<Rides>(context).currentRide != null);
    if (haveCurrentRide) {
      return RecordScreen();
    }
    bool havePastRide = (Provider.of<Rides>(context).pastRides.isNotEmpty);

    Widget pane;
    if (_pageIndex == 0) {
      if (havePastRide) {
        pane = RidesPane();
      } else {
        pane = NoRidesPane();
      }
    } else if (_pageIndex == 1) {
      pane = SettingsPane();
    } else {
      pane = InfoPane();
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: pane,
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (idx) {
          _setPageIndex(idx);
        },
        selectedIndex: _pageIndex,
        destinations: const <Widget>[
          NavigationDestination(
              icon: Icon(Icons.directions_bike),
              selectedIcon: Icon(Icons.directions_bike_outlined),
              label: "Fahrten"),
          NavigationDestination(
              icon: Icon(Icons.settings),
              selectedIcon: Icon(Icons.settings_outlined),
              label: "Einstellungen"),
          NavigationDestination(
              icon: Icon(Icons.info),
              selectedIcon: Icon(Icons.info_outlined),
              label: "Das Projekt"),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {Provider.of<Rides>(context, listen: false).startRide();},
          label: const Text("Losfahren"),
          icon: const Icon(Icons.play_arrow),
      )
    );
  }
}
