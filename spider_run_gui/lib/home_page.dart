import 'package:flutter/material.dart';
import 'package:spider_run_gui/list_port.dart';
import 'package:spider_run_gui/setting_page.dart';

class HomePage2 extends StatefulWidget {
  const HomePage2({super.key});

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class PageDestination {
  const PageDestination(this.label, this.icon, this.selectedIcon);
  final String label;
  final Widget icon;
  final Widget? selectedIcon;
}

class _HomePage2State extends State<HomePage2> {
  List<PageDestination> destinations = [
    const PageDestination(
      'Home',
      Icon(Icons.home_outlined),
      Icon(Icons.home),
    ),
    const PageDestination(
      'Settings',
      Icon(Icons.settings_outlined),
      Icon(Icons.settings),
    ),
  ];

  var selectedIndex = 0;

  Widget buildDrawer(BuildContext context) {
    return NavigationDrawer(
      onDestinationSelected: (value) {
        setState(() {
          selectedIndex = value;
        });
        Navigator.pop(context);
      },
      selectedIndex: selectedIndex,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Spider GUI',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...destinations.map((d) => NavigationDrawerDestination(
              icon: d.icon,
              label: Text(d.label),
              selectedIcon: d.selectedIcon,
            )),
      ],
    );
  }

  Widget buildRail(BuildContext context) {
    return NavigationRail(
      extended: true,
      onDestinationSelected: (value) {
        setState(() {
          selectedIndex = value;
        });
      },
      selectedIndex: selectedIndex,
      destinations: destinations
          .map((d) => NavigationRailDestination(
                icon: d.icon,
                label: Text(d.label),
                selectedIcon: d.selectedIcon,
              ))
          .toList(),
      elevation: 3.0,
    );
  }

  Widget getPage(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const ListPortPage();
        break;
      case 1:
        page = const SettingPage();
        break;
      default:
        page = const Placeholder();
        break;
    }
    return page;
  }

  Widget buildCompact(BuildContext context, Widget page) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spider GUI'),
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: page,
      drawer: buildDrawer(context),
    );
  }

  Widget buildLarge(BuildContext context, Widget page) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spider GUI'),
        shadowColor: Theme.of(context).shadowColor,
        // elevation: 1.0,
      ),
      body: Row(
        children: [
          buildRail(context),
          Expanded(child: page),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Widget page = getPage(context);
      if (constraints.maxWidth < 600) {
        return buildCompact(context, page);
      } else {
        return buildLarge(context, page);
      }
    });
  }
}
