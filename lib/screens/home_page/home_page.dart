import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodify/models/food_type.dart';
import 'package:foodify/screens/home_page/bloc/homerecipes_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodify/screens/recipe_info/bloc/recipe_info_bloc.dart';
import 'package:foodify/screens/recipe_info/recipe_info_screen.dart';
import 'package:foodify/screens/search_results/bloc/search_results_bloc.dart';
import 'package:foodify/screens/search_results/search_results_screen.dart';
import 'package:foodify/utils/theme.dart';
import 'package:foodify/widgets/food_type_widget.dart';
import 'package:foodify/widgets/horizontal_list.dart';
import 'package:foodify/widgets/list_items.dart';
import 'package:foodify/widgets/loading_widget.dart';

class HomeRecipeScreen extends StatefulWidget {
  const HomeRecipeScreen({Key? key}) : super(key: key);

  @override
  State<HomeRecipeScreen> createState() => _HomeRecipeScreenState();
}

class _HomeRecipeScreenState extends State<HomeRecipeScreen> {
  late final HomeRecipesBloc bloc;
  @override
  void initState() {
    bloc = BlocProvider.of<HomeRecipesBloc>(context);
    bloc.add(LoadHomeRecipe());
    initDynamicLinks(context);

    super.initState();
  }

  initDynamicLinks(BuildContext context) async {
    // FirebaseDynamicLinks.instance.onLink(
    //     onSuccess: (PendingDynamicLinkData? dynamicLink) async {
    //   final Uri? deepLink = dynamicLink?.link;

    //   if (deepLink != null) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => BlocProvider(
    //           create: (context) => RecipeInfoBloc(),
    //           child: RecipeInfo(
    //             id: deepLink.queryParameters['id']!,
    //           ),
    //         ),
    //       ),
    //     );
    //   }
    // }, onError: (OnLinkErrorException e) async {
    //   print('onLinkError');
    //   print(e.message);
    // });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => RecipeInfoBloc(),
            child: RecipeInfo(
              id: deepLink.queryParameters['id']!,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<HomeRecipesBloc, HomeRecipesState>(
          builder: (context, state) {
            if (state is HomeRecipesLoading) {
              return const Center(child: LoadingWidget());
            } else if (state is HomeRecipesSuccess) {
              return MyHomePage(
                breakfast: state.breakfast,
                cake: state.cake,
                drinks: state.drinks,
                burgers: state.burgers,
                lunch: state.lunch,
                pizza: state.pizza,
                rice: state.rice,
                title: '',
              );
            } else if (state is HomeRecipesError) {
              return Center(
                child: Container(
                  child: Text("Error"),
                ),
              );
            } else {
              return Center(
                child: Container(
                  child: Text("Noting happingng"),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<FoodType> breakfast;
  final List<FoodType> lunch;
  final List<FoodType> drinks;
  final List<FoodType> burgers;
  final List<FoodType> pizza;
  final List<FoodType> cake;
  final List<FoodType> rice;
  const MyHomePage(
      {Key? key,
      required this.title,
      required this.breakfast,
      required this.lunch,
      required this.drinks,
      required this.burgers,
      required this.pizza,
      required this.cake,
      required this.rice})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? myEmail;
  String? fmyName;
  String? lmyName;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  _fetch() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((ds) {
        myEmail = ds.data()!['email'] ?? '';
        fmyName = ds.data()!['firstName'] ?? '';
        lmyName = ds.data()!['secondName'] ?? '';

        print(myEmail);
      }).catchError((e) {
        print(e);
      });
    }
  }

  String greetingMessage() {
    var timeNow = DateTime.now().hour;

    if (timeNow <= 12) {
      return 'Good Morning,';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon,';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening,';
    } else {
      return 'Good Night,';
    }
  }

  Widget homescreen() {
    final isDarkMode = Theme.of(context).brightness == Brightness.light;
    return Stack(
      children: [
        ListView(
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: header("Category", "Category")),
            const HorizontalList(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: header("Popular Breakfast Recipes", "breakfast"),
            ),
            FoodTypeWidget(
              items: widget.breakfast,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: header("Best Lunch Recipes", "breakfast"),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...widget.lunch.map((meal) {
                    return ListItem(
                      meal: meal,
                    );
                  }).toList(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: header("Popular Drinks", "drinks"),
            ),
            const SizedBox(height: 10),
            FoodTypeWidget(items: widget.drinks),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: header("Best Burgers Recipes", "breakfast"),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...widget.burgers.map((meal) {
                    return ListItem(
                      meal: meal,
                    );
                  }).toList(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26.0),
              child: header("Pizza", "pizza"),
            ),
            const SizedBox(height: 10),
            FoodTypeWidget(items: widget.pizza),
            // Padding(
            //   padding: const EdgeInsets.all(14.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       header("Wants best cake", "cake"),
            //       ...widget.cake.map((meal) {
            //         return ListItem(
            //           meal: meal,
            //         );
            //       }).toList(),
            //     ],
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  header(String name, String title) {
    final isDarkMode = Theme.of(context).brightness == Brightness.light;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name,
            style: isDarkMode
                ? lightThemeData(context).textTheme.headline6
                : darkThemeData(context).textTheme.headline6),
        IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => SearchResultsBloc(),
                    child: SearchResults(
                      id: title,
                    ),
                  ),
                ),
              );
            },
            icon: Icon(Icons.arrow_forward_sharp))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.light;
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity * 1.2,
        decoration: BoxDecoration(
            color:
                isDarkMode ? Colors.greenAccent.withAlpha(40) : Colors.white),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greetingMessage(),
                              style: isDarkMode
                                  ? lightThemeData(context).textTheme.bodyText1
                                  : darkThemeData(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.black),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            FutureBuilder(
                              future: _fetch(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Text(
                                    "$fmyName$lmyName",
                                    style: isDarkMode
                                        ? lightThemeData(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(color: Colors.black)
                                        : darkThemeData(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(color: Colors.black),
                                  );
                                }
                                return Text("Loading data...Please wait");
                              },
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.black.withAlpha(100),
                          child: CircleAvatar(
                            backgroundImage: AssetImage(
                              isDarkMode
                                  ? "assets/logo/foodify.png"
                                  : "assets/logo/foodify.png",
                            ),
                            radius: 21,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: TextField(
                          onSubmitted: (value) {},
                          decoration: InputDecoration(
                            fillColor:
                                isDarkMode ? Colors.white : Color(0xffF2F4F5),
                            filled: true,
                            hintText: "Search Recipes..",
                            hintStyle: isDarkMode
                                ? lightThemeData(context)
                                    .textTheme
                                    .overline!
                                    .copyWith(fontSize: 13)
                                : darkThemeData(context)
                                    .textTheme
                                    .overline!
                                    .copyWith(
                                        color: Colors.black, fontSize: 13),
                            prefixIcon: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  size: 18,
                                  color: Colors.black,
                                ),
                                onPressed: () {}),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 20),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                style: BorderStyle.solid,
                                color: Theme.of(context).primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Colors.black.withOpacity(0),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: screenSize.height * 0,
              ),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    color: (isDarkMode
                        ? lightThemeData(context).scaffoldBackgroundColor
                        : darkThemeData(context).scaffoldBackgroundColor),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: homescreen(),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
