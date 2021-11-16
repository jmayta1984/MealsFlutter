import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meals/models/meal_category.dart';
import 'package:meals/screens/meal_list.dart';
import 'package:meals/utils/http_helper.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  late List categories;
  late HttpHelper httpHelper;

  @override
  void initState() {
    categories = [];
    httpHelper = HttpHelper();
    fetchCategories();
    super.initState();
  }

  void fetchCategories() {
    httpHelper.fetchCategories().then((value) {
      setState(() {
        categories = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemCount: categories.length,
      itemBuilder: (BuildContext context, int index) {
        return CategoryItem(category: categories[index]);
      },
    );
  }
}

class CategoryItem extends StatelessWidget {
  final MealCategory category;
  const CategoryItem({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => MealList(categoryName: category.name,)),
        );
      },
      child: Column(
        children: [
          Image.network(category.poster),
          Text(category.name),
        ],
      ),
    );
  }
}
