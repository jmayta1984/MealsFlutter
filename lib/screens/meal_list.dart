import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/utils/http_helper.dart';

class MealList extends StatefulWidget {
  final String categoryName;
  const MealList({Key? key, required this.categoryName}) : super(key: key);

  @override
  _MealListState createState() => _MealListState();
}

class _MealListState extends State<MealList> {
  late List meals;
  late HttpHelper httpHelper;

  @override
  void initState() {
    meals = [];
    httpHelper = HttpHelper();
    fetchMealsByCategory();
    super.initState();
  }

  void fetchMealsByCategory() {
    httpHelper.fetchMealsByCategory(widget.categoryName).then((value) {
      setState(() {
        meals = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) {
            return MealItem(meal: meals[index]);
          }),
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
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.meal.name),
        leading: Image.network(widget.meal.poster),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.favorite,
          ),
        ),
      ),
    );
  }
}
