import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:uuid/uuid.dart';

class PreparationForm extends StatefulWidget {
  const PreparationForm({Key? key, required this.onUpdate}) : super(key: key);

  final ValueChanged<List<Map<String, String>>> onUpdate;
  final Uuid uuid = const Uuid();

  @override
  _PreparationFormState createState() => _PreparationFormState();
}

class _PreparationFormState extends State<PreparationForm> {

  final List<Map<String, String>> fields = [];

  void _addFields(){
    fields.add({widget.uuid.v1(): ''});
    setState(() {});
  }

  void _updateField(String value, int index){
    final key = fields[index].keys.first;
    fields[index][key] = value;
    widget.onUpdate(fields);
  }

  void _removeField(int index){
    fields.removeAt(index);
    widget.onUpdate(fields);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Add Preparation steps',
          style: kBodyText.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15.0),

        for(var i = 0; i <fields.length; i++)
          Row(
            key: ValueKey(fields[i].keys.first),
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
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
