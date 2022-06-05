import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodify/models/search_results.dart';
import 'package:foodify/screens/recipe_info/bloc/recipe_info_bloc.dart';
import 'package:foodify/screens/recipe_info/recipe_info_screen.dart';
import 'package:foodify/screens/search_results/bloc/search_results_bloc.dart';
import 'package:foodify/utils/theme.dart';
import 'package:foodify/widgets/loading_widget.dart';
import 'package:http/http.dart' as http;

class Recipe {
  final String spoonacularSourceUrl;

  final int servings;
//has Equipment, Ingredients, Steps, e.t.c
  Recipe({required this.spoonacularSourceUrl, required this.servings});
//The spoonacularSourceURL displays the meals recipe in our webview
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
        spoonacularSourceUrl: map['spoonacularSourceUrl'],
        servings: map['servings']);
  }
}

class SearchResults extends StatefulWidget {
  final String id;
  const SearchResults({Key? key, required this.id}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late final SearchResultsBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of<SearchResultsBloc>(context);
    bloc.add(LoadSearchResults(name: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.light;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Image.asset(
            isDarkMode
                ? "assets/logo/foodify-text.png"
                : "assets/logo/foodify-text-darktheme.png",
            height: 65,
          ),
          elevation: 0,
          titleSpacing: 0,
          iconTheme:
              IconThemeData(color: isDarkMode ? Colors.black : Colors.white),
          backgroundColor: isDarkMode
              ? lightThemeData(context).scaffoldBackgroundColor
              : darkThemeData(context).scaffoldBackgroundColor,
        ),
        body: BlocBuilder<SearchResultsBloc, SearchResultsState>(
          builder: (context, state) {
            if (state is SearchResultsLoading) {
              return const Center(child: LoadingWidget());
            } else if (state is SearchResultsSuccess) {
              return Container(
                  child: SafeArea(
                      child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 13 / 16,
                  ),
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: [
                    ...state.results.map((result) {
                      return SearchResultItem(
                        result: result,
                      );
                    }).toList()
                  ],
                ),
              )));
            } else if (state is SearchResultsError) {
              return const Center(
                child: Text("Error"),
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

class SearchResultItem extends StatefulWidget {
  final SearchResult result;
  const SearchResultItem({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  _SearchResultresulttate createState() => _SearchResultresulttate();
}

class _SearchResultresulttate extends State<SearchResultItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => RecipeInfoBloc(),
              child: RecipeInfo(
                id: widget.result.id,
              ),
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                offset: Offset(-2, -2),
                blurRadius: 12,
                color: Color.fromRGBO(0, 0, 0, 0.05),
              ),
              BoxShadow(
                offset: Offset(2, 2),
                blurRadius: 5,
                color: Color.fromRGBO(0, 0, 0, 0.10),
              )
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Container(
                  height: 120,
                  foregroundDecoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: widget.result.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(9),
                child: FutureBuilder<int>(
                  future: fetchRecipe(widget.result.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      try {
                        return Text(
                          snapshot.data.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: lightThemeData(context)
                              .textTheme
                              .button!
                              .copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                        );
                      } catch (Exc) {
                        print(Exc);
                        rethrow;
                      }
                    }
                    return Text("L");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final String _baseURL = "api.spoonacular.com";
const String API_KEY = "098fc724ead7426f990c7fe096adb598";

Future<int> fetchRecipe(String id) async {
  Map<String, String> parameters = {
    'includeNutrition': 'false',
    'apiKey': API_KEY,
  };
//we call in our recipe id in the Uri, and parse in our parameters
  Uri uri = Uri.https(
    _baseURL,
    '/recipes/$id/information',
    parameters,
  );
//And also specify that we want our header to return a json object
  Map<String, String> headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };
//finally, we put our response in a try catch block
  try {
    var response = await http.get(uri, headers: headers);
    Map<String, dynamic> data = json.decode(response.body);
    Recipe recipe = Recipe.fromMap(data);

    return recipe.servings;
  } catch (err) {
    throw err.toString();
  }
}
