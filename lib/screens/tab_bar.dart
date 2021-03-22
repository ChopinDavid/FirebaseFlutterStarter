import 'package:firebase_flutter_starter/screens/home_page.dart';
import 'package:firebase_flutter_starter/screens/profile_page.dart';
import 'package:firebase_flutter_starter/utils/starter_icons.dart';
import 'package:flutter/material.dart';

enum Page {
  home,
  profile,
}

class HugTabBar extends StatefulWidget {
  final Page initialPage;

  const HugTabBar({
    Key? key,
    Page? initialPage,
  })  : this.initialPage = initialPage ?? Page.home,
        super(key: key);

  @override
  _HugTabBarState createState() => _HugTabBarState();
}

class _HugTabBarState extends State<HugTabBar> {
  int? _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = Page.values.indexOf(widget.initialPage);
  }

  List<Widget> _createWidgetsForTabs() {
    return [
      HomePage(),
      ProfilePage(
        onProfilePictureUpdated: () {
          setState(() {});
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    const iconBottomPadding = 4.0;
    const iconTopPadding = 10.0;

    return Scaffold(
      body: _PrimaryContentBody(_createWidgetsForTabs()[_currentIndex!]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex!,
        selectedFontSize: 12.0,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(
                bottom: iconBottomPadding,
                top: iconTopPadding,
              ),
              child: Icon(StarterIcons.home, key: Key('home-icon')),
            ),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(
                bottom: iconBottomPadding,
                top: iconTopPadding,
              ),
              child: Icon(StarterIcons.profile, key: Key('profile-icon')),
            ),
            label: 'PROFILE',
          ),
        ],
      ),
    );
  }
}

class _PrimaryContentBody extends StatefulWidget {
  final Widget child;

  const _PrimaryContentBody(this.child);

  @override
  __PrimaryContentBodyState createState() => __PrimaryContentBodyState();
}

class __PrimaryContentBodyState extends State<_PrimaryContentBody> {
  @override
  void initState() {
    super.initState();
    //BeaconService().startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
