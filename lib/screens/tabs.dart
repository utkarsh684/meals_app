import 'package:flutter/material.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/main_drawer.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/providers/meals_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Map<Filter, bool> kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  final List<Meal> _favoriteMeals = [];
  int _selectedPageIndex = 0;

  Map<Filter, bool> _selectedFilters = kInitialFilters;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _toogleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      showMessage('Meal is no lonager a favorite');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      showMessage('Meal is marked as favorite');
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(currentFilters: _selectedFilters),
        ),
      );
      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Meal> meals = ref.watch(mealsProvider);
    List<Meal> availableMeals =
        meals.where((Meal meal) {
          if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
            return false;
          }
          if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
            return false;
          }
          if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
            return false;
          }
          if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
            return false;
          }
          return true;
        }).toList();
    Widget activePage = CategoriesScreen(
      onToogleFavorite: _toogleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        title: null,
        meals: _favoriteMeals,
        onToggleFavorite: _toogleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(title: Text(activePageTitle)),
      drawer: MainDrawer(onSelected: _setScreen),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
