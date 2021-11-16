import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/models/favorite_list.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:provider/provider.dart';

import '../rounded_button.dart';

class EditListForm extends StatefulWidget {
  const EditListForm({Key? key, required this.listID}) : super(key: key);

  final String listID;

  @override
  _EditListFormState createState() => _EditListFormState();
}

class _EditListFormState extends State<EditListForm> {
  late String _name;
  late String _description;
  final Timestamp timestamp = Timestamp.now();
  bool _isSaving = false;
  final TextEditingController _listNameController = TextEditingController();
  final TextEditingController _listDescriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FavoriteList? favoriteList;

  @override
  void initState() {
    super.initState();
    getListDetails();
  }


  getListDetails() async {
    setState(() {
      _isSaving = true;
    });
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<FirebaseOperations>(context, listen: false).getUserId)
        .collection('favorites')
        .doc(widget.listID)
        .get();
    favoriteList = FavoriteList.fromDocument(doc);
    _listNameController.text = favoriteList!.name;
    _listDescriptionController.text = favoriteList!.description;
    setState(() {
      _isSaving = false;
    });
  }

  @override
  void dispose() {
    _listNameController.dispose();
    _listDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !_isSaving
        ? Container(
      margin: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _listNameController,
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
            TextFormField(
              controller: _listDescriptionController,
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
                  _isSaving = true;
                });

                Provider.of<FirebaseOperations>(context, listen: false)
                    .editFavoriteList(
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .getUserId,
                  widget.listID,
                  {
                    'name': _name,
                    'description': _description,
                  },
                ).whenComplete(() {
                  setState(() {
                    _isSaving = false;
                  });
                  Navigator.pop(context);
                });
              },
              buttonName: 'Update',
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    )
        : loadingAnimation('Loading...');
  }
}
