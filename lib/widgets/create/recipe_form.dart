import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_share/config/size_config.dart';
import 'package:food_share/utils/form_values.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:food_share/widgets/create/hashtag_field.dart';
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
  final _values = FormValues();
  bool _isUploading = false;

  submitRecipeValues() {
    if (_values.name!.isNotEmpty &&
        _values.description!.isNotEmpty &&
        _values.cookingTime!.isNotEmpty &&
        _values.servings!.isNotEmpty &&
        _values.ingredients!.isNotEmpty &&
        _values.preparation!.isNotEmpty &&
        _values.hashtagId!.isNotEmpty) {
      setState(() {
        _isUploading = true;
      });
      widget.onSubmit(_values);
    } else {
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
    SizeConfig.init(context);
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
                    _values.name = value;
                  },
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Description',
                    filled: true,
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    _values.description = value;
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
                    _values.cookingTime = value;
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
                    _values.servings = value;
                  },
                ),
                const SizedBox(height: 30.0),
                IngredientsForm(
                  onUpdate: (value) {
                    _values.ingredients = value;
                  },
                ),
                const SizedBox(height: 20.0),
                PreparationForm(
                  onUpdate: (value) {
                    _values.preparation = value;
                  },
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  height: SizeConfig.defaultSize * 20,
                  width: SizeConfig.defaultSize * 80,
                  child: HashtagField(
                    onUpdate: (value) {
                      _values.hashtagId = value;
                    },
                  ),
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
