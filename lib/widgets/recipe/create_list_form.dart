import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:food_share/utils/palette.dart';
import 'package:food_share/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateListForm extends StatefulWidget {
  const CreateListForm({Key? key}) : super(key: key);

  @override
  _CreateListFormState createState() => _CreateListFormState();
}

class _CreateListFormState extends State<CreateListForm> {
  late String _name;
  late String _description;
  String listID = const Uuid().v4();
  final Timestamp timestamp = Timestamp.now();
  bool _isCreating = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return !_isCreating
        ? Container(
            margin: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // _buildFormField('List name', 'List name is required', _name),
                  TextFormField(
                    cursorColor: kBlue,
                    decoration: const InputDecoration(
                      labelText: 'List name',
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kBlue)),
                      labelStyle: TextStyle(
                        color: kBlue,
                      ),
                    ),
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return 'List name is required';
                      }
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  // _buildFormField('Description (optional)', '', _description),
                  TextFormField(
                    cursorColor: kBlue,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kBlue)),
                      labelStyle: TextStyle(
                        color: kBlue,
                      ),
                    ),
                    onSaved: (value) {
                      _description = value!;
                    },
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  RoundedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _formKey.currentState!.save();

                      setState(() {
                        _isCreating = true;
                      });

                      Provider.of<FirebaseOperations>(context, listen: false)
                          .createFavoriteList(
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getUserId,
                        listID,
                        {
                          'name': _name,
                          'id': listID,
                          'description': _description,
                          'recipe_count': 0,
                          'timestamp': timestamp,
                          'lastEdited': timestamp,
                        },
                      ).whenComplete(() {
                        setState(() {
                          _isCreating = false;
                        });
                        Navigator.pop(context);
                      });
                    },
                    buttonName: 'Create',
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          )
        : loadingAnimation('Creating list...');
  }
}
