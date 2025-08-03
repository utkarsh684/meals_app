import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:transparent_image/transparent_image.dart';

class MealsDetails extends StatelessWidget {
  const MealsDetails({super.key,required this.meal,required this.onToggleFavorite});
  
  final Meal meal;
  final void Function(Meal meal) onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final String ingredients=meal.ingredients.join('\n');
    final String steps=meal.steps.join('\n');

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),),
        actions: [
          IconButton(onPressed: () {
            onToggleFavorite(meal);
          }, icon: Icon(Icons.star),),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(meal.imageUrl),
            fit: BoxFit.cover,
            height: 500,
            width: double.infinity,
          ),
          SizedBox(height: 20,),
          Text(
            'Ingredients',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          SizedBox(height: 20),
          Text(ingredients,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.white),),
          SizedBox(height: 20,),
          Text(
            'Steps',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          SizedBox(height: 8),
          Text(steps,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.white),),
        ],
      ),
    );
  }
}

