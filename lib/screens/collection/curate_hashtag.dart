import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/routes/curate_hashtag_arguments.dart';
import 'package:food_share/services/firebase_operations.dart';
import 'package:food_share/utils/loading_animation.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CurateHashtag extends StatefulWidget {
  const CurateHashtag({Key? key, required this.arguments}) : super(key: key);

  final CurateHashtagArguments arguments;

  @override
  _CurateHashtagState createState() => _CurateHashtagState();
}

class _CurateHashtagState extends State<CurateHashtag> {
  late String _name;
  late String _imgUrl;
  String hashtagID = const Uuid().v4();
  final Timestamp timestamp = Timestamp.now();
  bool _isCreating = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:  !_isCreating
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
                  labelText: 'Hashtag name',
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
                    return 'Hashtag name is required';
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
                  labelText: 'Hashtag image',
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
                    return 'Hashtag image is required';
                  }
                },
                onSaved: (value) {
                  _imgUrl = value!;
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
                      .addHashtag(
                    widget.arguments.collectionID,
                    hashtagID,
                    {
                      'name': _name.toLowerCase(),
                      'hashtag_id': hashtagID,
                      'imageUrl': _imgUrl,
                      'timestamp': timestamp,
                    },
                    _name.toLowerCase(),
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
          : loadingAnimation('Creating hashtag...'),
    );
  }
}
