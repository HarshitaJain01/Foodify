import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodify/animation/animation.dart';
import 'package:foodify/screens/search_results/bloc/search_results_bloc.dart';
import 'package:foodify/screens/search_results/search_results_screen.dart';
import 'package:foodify/utils/theme.dart';

class HorizontalList extends StatelessWidget {
  const HorizontalList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          SizedBox(width: 10),
          ChipWidget("Drinks"),
          // ChipWidget("Baking"),
          ChipWidget("Desserts"),
          ChipWidget("Vegetarian"),
          ChipWidget("Sauces"),
          // ChipWidget("Stir Fry"),
          ChipWidget("Seafood"),
          ChipWidget("Meat"),
          // ChipWidget("Lamb"),
          // ChipWidget("Pork"),
          // ChipWidget("Poultry"),
          // ChipWidget("Duck"),
          // ChipWidget("Turkey"),
          ChipWidget("Chicken"),
          ChipWidget("Sausages"),
          // ChipWidget("Mince"),
          ChipWidget("Burgers"),
          ChipWidget("Pies"),
          // ChipWidget("Pasta"),
          // ChipWidget("Noodles"),
          // ChipWidget("Rice"),
          ChipWidget("Pizza"),
          // ChipWidget("Sides"),
          ChipWidget("Salads"),
          // ChipWidget("Soups"),
          ChipWidget("Snacks"),
        ],
      ),
    );
  }
}

class ChipWidget extends StatelessWidget {
  final String text;
  const ChipWidget(
    this.text,
  );

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DelayedDisplay(
        delay: const Duration(microseconds: 600),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => SearchResultsBloc(),
                  child: SearchResults(
                    id: text,
                  ),
                ),
              ),
            );
          },
          child: Container(
            height: 103,
            width: 103,
             
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              
              color: isDarkMode ? Color (0xffF2F4F5) : Color(0xffF2F4F5).withAlpha(90),
               
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                
                
                
                
                
               
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                  child: Column(
                    children: [
                      Image.asset(
                  "assets/HorizontalList/$text.png",
                  height: 60,
                  alignment: Alignment.center,
                  
                ),
                
                const SizedBox(height: 8,),
                      Text(
                        text,
                        style:  lightThemeData(context).textTheme.subtitle2 ,
                        
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
