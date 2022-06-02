import 'package:bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodify/screens/home_page/bloc/homerecipes_bloc.dart';
import 'package:foodify/screens/home_page/home_page.dart';
import 'package:foodify/screens/search_page/cubit/search_page_cubit.dart';
import 'package:foodify/screens/search_page/search_page.dart';
import 'package:foodify/utils/theme.dart';


class BottomNavView extends StatefulWidget {
  @override
  _BottomNavViewState createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  late PersistentTabController _controller;

  final List<Widget> _widgetOptions = <Widget>[
    
    BlocProvider(
      create: (context) => HomeRecipesBloc(),
      child: const HomeRecipeScreen(),
    ),
    BlocProvider(
      create: (context) => SearchPageCubit(),
      child: const SearchPage(),
    ),
    BlocProvider(
      create: (context) => HomeRecipesBloc(),
      child: const HomeRecipeScreen(),
    ),
    BlocProvider(
      create: (context) => HomeRecipesBloc(),
      child: const HomeRecipeScreen(),
    ),
    
  ];
  List<PersistentBottomNavBarItem> _navBarsItems() {
    final isDarkMode = Theme.of(context).brightness == Brightness.light;
    return [
      PersistentBottomNavBarItem(
        inactiveColorPrimary: isDarkMode?  Colors.grey.shade600 : Colors.white70,
        iconSize: 24,
        icon: const Icon(
          CupertinoIcons.home,
        ),
        activeColorPrimary: Colors.blueAccent,
        title: ("Home"),
      ),
      PersistentBottomNavBarItem(
        inactiveColorPrimary: isDarkMode?  Colors.grey.shade600 : Colors.white70,
        iconSize: 24,
        icon: const Icon(
          CupertinoIcons.search,
        ),
        activeColorPrimary: Colors.blueAccent,
        title: ("Search"),
      ),
      PersistentBottomNavBarItem(
        inactiveColorPrimary: isDarkMode?  Colors.grey.shade600 : Colors.white70,
        icon: const Icon(
          CupertinoIcons.heart_fill,
        ),
        iconSize: 24,
        activeColorPrimary: Colors.blueAccent,
        title: ("Favorite"),
      ),
      PersistentBottomNavBarItem(
        inactiveColorPrimary: isDarkMode?  Colors.grey.shade600 : Colors.white70,
        icon: Icon(
          Icons.list,
        ),
        iconSize: 24,
        activeColorPrimary: Colors.blueAccent,
        title: ("More"),
      ),
      
    ];
  }

  @override
  void initState() {
    _controller = PersistentTabController(initialIndex: 0);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.light;
    return Center(
      child: PersistentTabView(
        this.context,
        controller: _controller,
        screens: _widgetOptions,
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: isDarkMode? lightThemeData(context).scaffoldBackgroundColor : darkThemeData(context).scaffoldBackgroundColor,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardShows: true,
        popAllScreensOnTapOfSelectedTab: true,
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }
}
