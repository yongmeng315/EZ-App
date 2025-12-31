import 'dart:async';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../utils/navigation_utils.dart';
import '../utils/responsive_layout.dart';

class PageWrapper extends StatefulWidget {
  const PageWrapper({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() {
    return _PageWrapper();
  }
}

class _PageWrapper extends State<PageWrapper>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late String _selected;
  String _selectedDrawer = 'Home';

  // Map<String, dynamic> selectionDrawerMap = NavigationUtils.homeTab;
  int navigationCount = 0;
  bool _expanded = false;
  final double NAV_BAR_WIDTH = 200;

  // StreamController<DatabaseEvent> streamController =
  //     StreamController.broadcast();
  Map<String, dynamic>? profileDropDownSelection;

  final List<Map<String, dynamic>> _profileDropDown = [
    {'title': 'User Profile', 'path': '/profile', 'icon': Icons.person},
    {
      'title': 'Add New User',
      'path': '/add_new_user',
      'icon': Icons.person_add_alt_1_rounded,
    },
    {'title': 'Logout', 'path': '/login', 'icon': Icons.logout},
  ];
  Map<String, dynamic>? applicationDropDownSelection;

  final List<Map<String, dynamic>> _applicationsDropDown = [];

  @override
  void initState() {
    super.initState();
    NavigationUtils.initializeNavigationUtils();
  }

  Widget _buildDrawerWidget() {
    List<Map<String, dynamic>> tabs = NavigationUtils.navigationList;

    if (ResponsiveLayout.isSmallScreen(context)) {
      return Positioned(
        top: 4,
        bottom: _expanded ? 4 : null,
        left: 4,
        right:
            MediaQuery.of(context).size.width -
            (_expanded ? NAV_BAR_WIDTH : 40),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.linear,
            // height: 40,
            // width: 40,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadiusGeometry.circular(16),
            // ),
            child: _expanded
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'EZ APP',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Divider(thickness: 2),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final Map<String, dynamic> tab = tabs[index];

                            return ListTile(
                              title: Text(
                                tab.keys.first.toString(),
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      color:
                                          GoRouter.of(context).state.path ==
                                              tab.values.first['route']
                                          ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                          : Colors.grey,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              leading: SizedBox(
                                width: 40,
                                child: Icon(
                                  tab.values.first['icon'],
                                  color:
                                      GoRouter.of(context).state.path ==
                                          tab.values.first['route']
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                                ),
                              ),
                              onTap: () {
                                GoRouter.of(
                                  context,
                                ).go(tab.values.first['route']);
                                setState(() {
                                  _expanded = false;
                                });
                              },
                            );
                          },
                          itemCount: NavigationUtils.navigationList.length,
                        ),
                      ),
                      Container(
                        height: 36,
                        width: NAV_BAR_WIDTH - 8,
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(4, 4),
                              color: Colors.grey,
                              blurRadius: 4,
                            ),
                            BoxShadow(
                              offset: Offset(-4, 0),
                              color: Colors.grey,
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _expanded = !_expanded;
                            });
                          },
                          icon: Icon(
                            _expanded ? Icons.arrow_left : Icons.arrow_right,
                          ),
                        ),
                      ),
                    ],
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                    icon: Icon(Icons.menu, size: 20),
                    style: ButtonStyle(

                      backgroundColor: WidgetStatePropertyAll(Theme.of(context).scaffoldBackgroundColor),
                      iconSize: WidgetStatePropertyAll(20),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(16),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      );
    }

    return Positioned(
      top: 8,
      bottom: 8,
      left: 8,
      right:
          MediaQuery.of(context).size.width -
          ((_expanded ? NAV_BAR_WIDTH : NAV_BAR_WIDTH / 3) + 8),
      child: Material(
        clipBehavior: Clip.hardEdge,
        animationDuration: Duration(milliseconds: 300),
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
          width: _expanded ? NAV_BAR_WIDTH : NAV_BAR_WIDTH / 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            shape: BoxShape.rectangle,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          padding: EdgeInsets.all(8),
          child: _expanded
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'EZ APP',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Divider(thickness: 2),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> tab = tabs[index];

                          return ListTile(
                            title: Text(
                              tab.keys.first.toString(),
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    color:
                                        GoRouter.of(context).state.path ==
                                            tab.values.first['route']
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            leading: SizedBox(
                              width: 40,
                              child: Icon(
                                tab.values.first['icon'],
                                color:
                                    GoRouter.of(context).state.path ==
                                        tab.values.first['route']
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                              ),
                            ),
                            onTap: () {
                              GoRouter.of(
                                context,
                              ).go(tab.values.first['route']);
                            },
                          );
                        },
                        itemCount: NavigationUtils.navigationList.length,
                      ),
                    ),
                    Container(
                      height: 36,
                      width: NAV_BAR_WIDTH - 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(4, 4),
                            color: Colors.grey,
                            blurRadius: 4,
                          ),
                          BoxShadow(
                            offset: Offset(-4, 0),
                            color: Colors.grey,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                        icon: Icon(
                          _expanded ? Icons.arrow_left : Icons.arrow_right,
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.gite_outlined),
                    Divider(thickness: 2),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final Map<String, dynamic> tab = tabs[index];

                          return IconButton(
                            onPressed: () {
                              GoRouter.of(
                                context,
                              ).go(tab.values.first['route']);

                            },
                            icon: Icon(
                              tab.values.first['icon'],
                              color:
                                  GoRouter.of(context).state.path ==
                                      tab.values.first['route']
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                            ),
                          );
                        },
                        itemCount: NavigationUtils.navigationList.length,
                      ),
                    ),
                    Container(
                      height: 36,
                      width: NAV_BAR_WIDTH / 3 - 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(4, 4),
                            color: Colors.grey,
                            blurRadius: 4,
                          ),
                          BoxShadow(
                            offset: Offset(-4, 0),
                            color: Colors.grey,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _expanded = !_expanded;
                          });
                        },
                        icon: Icon(
                          _expanded ? Icons.arrow_left : Icons.arrow_right,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    _selected = GoRouterState.of(context).uri.toString();

    return GestureDetector(
      onTap: () {
        if (!_expanded) {
          return;
        }
        if (_expanded) {
          setState(() {
            _expanded = false;
          });
          return;
        }
      },
      child: Stack(
        children: [
          // Positioned.fill(child: background()),
          Padding(
            padding:
                // !GeneralUtils.firebaseAuth.currentUser!.emailVerified ||
                //         !AuthStates.appUser!.onboarded
                //     ? EdgeInsets.zero
                //     :
                // ResponsiveLayout.isLargeScreen(context)
                // ? EdgeInsets.only(
                //     left: (_expanded ? NAV_BAR_WIDTH : NAV_BAR_WIDTH / 3) + 16,
                //   )
                // :
                EdgeInsets.zero,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              key: _scaffoldKey,
              body: Container(
                constraints: BoxConstraints(minHeight: height, minWidth: width),

                color: Theme.of(context).scaffoldBackgroundColor,
                child: widget.child,
              ),
            ),
          ),

          _buildDrawerWidget(),

          // Consumer<AuthManager>(
          //   builder: (context, authManager, child) {
          //     return // GoRouterState.of(context).fullPath!.split('/').length == 2 &&
          //     GoRouterState.of(context).fullPath != '/boarding' &&
          //             GoRouterState.of(context).fullPath != '/login' &&
          //             GoRouterState.of(context).fullPath !=
          //                 '/registration_page' &&
          //             GoRouterState.of(context).fullPath !=
          //                 '/forgot_password_page' &&
          //             GoRouterState.of(context).fullPath !=
          //                 '/forgot_password_otp' &&
          //             GoRouterState.of(context).fullPath !=
          //                 '/otp_verification_page' &&
          //             GoRouterState.of(context).fullPath !=
          //                 '/pin_passcode_page' &&
          //             GoRouterState.of(context).fullPath !=
          //                 '/confirm_pin_passcode_page' &&
          //             GoRouterState.of(context).fullPath !=
          //                 '/signin_with_passcode_page' &&
          //             GoRouterState.of(context).fullPath !=
          //                 '/signin_with_faceid_page' &&
          //             GoRouterState.of(context).fullPath !=
          //                 '/signin_with_touchid_page' &&
          //             GoRouterState.of(context).fullPath !=
          //                 '/allow_faceid_page' &&
          //             GoRouterState.of(context).fullPath !=
          //                 '/allow_touchid_page' &&
          //             GoRouterState.of(context).fullPath !=
          //                 '/enter_password_page' &&
          //             GoRouterState.of(context).fullPath !=
          //                 '/confirm_password_page' &&
          //             GoRouterState.of(context).fullPath != '/camera' &&
          //             authManager.isBNBVisible
          //         ? Positioned(
          //             bottom: Platform.isAndroid
          //                 ? 16
          //                 : Platform.isIOS
          //                 ? 0
          //                 : 0,
          //             right: 16,
          //             left: 16,
          //             child: MyBottomNavigationBar(),
          //           )
          //         : SizedBox();
          //   },
          // ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState!.dispose();
    }

    super.dispose();
  }
}
