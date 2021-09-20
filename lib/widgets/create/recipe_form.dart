import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/utils/form_values.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:food_share/widgets/create/ingredients_form.dart';
import 'package:food_share/widgets/create/preparation_form.dart';
import 'package:food_share/widgets/rounded_button.dart';
import 'package:flutter/services.dart';

class RecipeForm extends StatefulWidget {
  const RecipeForm({Key? key, required this.onSubmit}) : super(key: key);

  final ValueChanged<FormValues> onSubmit;

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final values = FormValues();
  bool _isUploading = false;

  submitRecipeValues(){
    if(values.name!.isNotEmpty && values.description!.isNotEmpty && values.cookingTime!.isNotEmpty && values.servings!.isNotEmpty && values.ingredients!.isNotEmpty && values.preparation!.isNotEmpty){
      setState(() {
        _isUploading = true;
      });
      widget.onSubmit(values);
    } else{
      setState(() {
        _isUploading = false;
      });
      Fluttertoast.showToast(
          msg: 'Please fill all recipe form fields!!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: _isUploading == false
          ? Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Name',
                    filled: true,
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
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
                  onChanged: (value) {
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  onChanged: (value) {
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  onChanged: (value) {
                    values.servings = value;
                  },
                ),
                const SizedBox(height: 30.0),
                IngredientsForm(
                  onUpdate: (value) {
                    values.ingredients = value;
                  },
                ),
                const SizedBox(height: 20.0),
                PreparationForm(
                  onUpdate: (value) {
                    values.preparation = value;
                  },
                ),
                const SizedBox(height: 40.0),
                RoundedButton(
                  buttonName: 'Submit',
                  onPressed: () {
                    submitRecipeValues();
                  },
                ),
                const SizedBox(height: 40.0),
              ],
            )
          : loadingAnimation('Submitting recipe details...'),
    );
  }
}
