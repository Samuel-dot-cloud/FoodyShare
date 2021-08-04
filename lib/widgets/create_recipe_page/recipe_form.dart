import 'package:flutter/material.dart';
import 'package:food_share/utils/form_values.dart';
import 'package:food_share/widgets/create_recipe_page/ingredients_form.dart';
import 'package:food_share/widgets/rounded_button.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({Key? key, required this.onSubmit}) : super(key: key);

  final ValueChanged<FormValues> onSubmit;

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
final values = FormValues();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Name',
            filled: true,
          ),
          keyboardType: TextInputType.text,
          onChanged: (value){
            values.name = value;
          },
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Description',
            filled: true,
          ),
          keyboardType: TextInputType.text,
          onChanged: (value){
            values.description = value;
          },
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Cooking Time',
            filled: true,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value){
            values.cookingTime = value;
          },
        ),
        const SizedBox(height: 10.0),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Servings',
            filled: true,
          ),
          keyboardType: TextInputType.number,
          onChanged: (value){
            values.servings = value;
          },
        ),
        const SizedBox(height: 30.0),
        IngredientsForm(onUpdate: (value) {
          values.ingredients = value;
        },
        ),
        const SizedBox(height: 40.0),
        RoundedButton(
          buttonName: 'Submit',
            onPressed: (){
            widget.onSubmit(values);
            print(values);
            },
        ),
        const SizedBox(height: 40.0),
      ],
    );
  }
}
