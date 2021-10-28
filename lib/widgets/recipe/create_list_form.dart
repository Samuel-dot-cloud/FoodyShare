import 'package:flutter/material.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/rounded_button.dart';

class CreateListForm extends StatefulWidget {
  const CreateListForm({Key? key}) : super(key: key);

  @override
  _CreateListFormState createState() => _CreateListFormState();
}

class _CreateListFormState extends State<CreateListForm> {
  late final String _name = '';
  late final String _description = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildFormField('List name', 'List name is required', _name),
            const SizedBox(
              height: 30.0,
            ),
            _buildFormField('Description (optional)', '', _description),
            const SizedBox(
              height: 30.0,
            ),
            RoundedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
                _formKey.currentState!.save();
              },
              buttonName: 'Create',
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildFormField(String text, String errorText, String _data) {
    return TextFormField(
      cursorColor: kBlue,
      decoration: InputDecoration(
        labelText: text,
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        focusedBorder:
            const UnderlineInputBorder(borderSide: BorderSide(color: kBlue)),
        labelStyle: const TextStyle(
          color: kBlue,
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return errorText;
        }
      },
      onSaved: (value) {
        _data = value!;
      },
    );
  }
}
