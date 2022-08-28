import 'package:flutter/material.dart';

import '../components/side_nav.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 30.0,
        ),
      );

  Widget buildMenuItems(BuildContext context) {
    SideNavMenuItems sn = SideNavMenuItems(context: context);
    return Wrap(
      runSpacing: 12,
      children: sn.menuList(),
    );
  }
}
