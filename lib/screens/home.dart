import 'package:flutter/material.dart';
import 'package:meals/screens/category_list.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CategoryList(),
    );
  }
}
