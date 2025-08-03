import 'package:flutter/material.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/models/meal.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Meal> _favoriteMeals=[];
  int _selectedPageIndex=0;

  void showMessage(String message){
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toogleMealFavoriteStatus(Meal meal){
    final isExisting = _favoriteMeals.contains(meal);

    if(isExisting){
      setState(() {
        _favoriteMeals.remove(meal);
      });
      showMessage('Meal is no lonager a favorite');
    } else{
      setState(() {
        _favoriteMeals.add(meal);
      });
      showMessage('Meal is marked as favorite');
    }
  }
  void _selectPage(int index){
    setState(() {
      _selectedPageIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget activePage= CategoriesScreen(onToogleFavorite: _toogleMealFavoriteStatus,);
    var activePageTitle='Categories';

    if(_selectedPageIndex==1){
      activePage=MealsScreen(
        title:null,
        meals: _favoriteMeals,
        onToggleFavorite: _toogleMealFavoriteStatus,
      );
      activePageTitle='Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.set_meal),label:'Categories',),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),label: 'Favorites',),
        ],
      ),
    );
  }
}
