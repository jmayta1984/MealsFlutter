import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/utils/db_helper.dart';
import 'package:meals/utils/http_helper.dart';

class MealList extends StatefulWidget {
  final String categoryName;
  const MealList({Key? key, required this.categoryName}) : super(key: key);

  @override
  _MealListState createState() => _MealListState();
}

class _MealListState extends State<MealList> {
  late Future<List> meals;
  late HttpHelper httpHelper;

  @override
  void initState() {
    httpHelper = HttpHelper();
    meals = fetchMealsByCategory();
    super.initState();
  }

  Future<List> fetchMealsByCategory() {
    return httpHelper.fetchMealsByCategory(widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await showSearch(
                  context: context,
                  delegate: MealSearch(meals),
                );
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: FutureBuilder<List>(
        future: meals,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return MealItem(meal: snapshot.data?[index]);
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class MealItem extends StatefulWidget {
  final Meal meal;
  const MealItem({Key? key, required this.meal}) : super(key: key);

  @override
  _MealItemState createState() => _MealItemState();
}

class _MealItemState extends State<MealItem> {
  late bool favorite;
  late DbHelper dbHelper;

  @override
  void initState() {
    favorite = false;
    dbHelper = DbHelper();
    isFavorite();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.meal.name),
        leading: Image.network(widget.meal.poster),
        trailing: IconButton(
          onPressed: () {
            favorite
                ? dbHelper.delete(widget.meal)
                : dbHelper.insert(widget.meal);
            setState(() {
              favorite = !favorite;
            });
          },
          icon: Icon(
            Icons.favorite,
            color: favorite ? Colors.red : Colors.grey,
          ),
        ),
      ),
    );
  }

  Future isFavorite() async {
    await dbHelper.openDb();
    final result = await dbHelper.isFavorite(widget.meal);
    setState(() {
      favorite = result;
    });
  }
}

class MealSearch extends SearchDelegate<String?> {
  final Future<List> meals;
  List suggestions = [];

  MealSearch(this.meals);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    if (!suggestions.contains(query) && query != '') {
      suggestions.add(query);
    }
    return FutureBuilder<List>(
      future: filterMeals(),
      builder: (context, snapshot) {
        return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              if (snapshot.hasData) {
                return MealItem(meal: snapshot.data?[index]);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            });
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SuggestionsList(suggestions: suggestions);
  }

  Future<List> filterMeals() async {
    List initialMeals;
    List resultMeals;
    initialMeals = await meals;
    resultMeals = initialMeals
        .where((element) =>
            element.name.toUpperCase().contains(query.toUpperCase()))
        .toList();
    return resultMeals;
  }
}

class SuggestionsList extends StatefulWidget {
  final List suggestions;
  SuggestionsList({Key? key, required this.suggestions})
      : super(key: key);

  @override
  _SuggestionsListState createState() => _SuggestionsListState();
}

class _SuggestionsListState extends State<SuggestionsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.suggestions.length,
      itemBuilder: (context, index) {
        return GestureDetector(
            onTap: () {
              //query = suggestions[index];
              //showResults(context);
            },
            child: ListTile(
              title: Text(widget.suggestions[index]),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    widget.suggestions.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete),
              ),
            ));
      },
    );
  }
}
