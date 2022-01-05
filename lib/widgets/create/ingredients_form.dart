import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/utils/palette.dart';
import 'package:uuid/uuid.dart';

class IngredientsForm extends StatefulWidget {
  const IngredientsForm({Key? key, required this.onUpdate}) : super(key: key);

  final ValueChanged<List<Map<String, String>>> onUpdate;
  final Uuid uuid = const Uuid();

  @override
  _IngredientsFormState createState() => _IngredientsFormState();
}

class _IngredientsFormState extends State<IngredientsForm> {
  final List<Map<String, String>> _fields = [];
  
  void _addFields(){
    _fields.add({widget.uuid.v1(): ''});
    setState(() {});
  }

  void _updateField(String value, int index){
    final key = _fields[index].keys.first;
    _fields[index][key] = value;
    widget.onUpdate(_fields);
  }

  void _removeField(int index){
    _fields.removeAt(index);
    widget.onUpdate(_fields);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Add Ingredients',
          style: kBodyText.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15.0),

        for(var i = 0; i <_fields.length; i++)
        Row(
          key: ValueKey(_fields[i].keys.first),
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onChanged: (value){
                    _updateField(value, i);
                  },
                ),
              ),

            ),
            IconButton(
                onPressed: (){
                  _removeField(i);
                },
                icon: const Icon(
                  FontAwesomeIcons.minusCircle,
                  color: Colors.red,
                ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            _addFields();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                  Icons.add,
                color: kBlue,
                size: 20.0,
              ),
              Text(
                'Add field',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
