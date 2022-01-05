import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_share/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../services/firebase_operations.dart';
import '../utils/loading_animation.dart';

class ReportForm extends StatefulWidget {
  const ReportForm({Key? key, required this.category, required this.reportedID}) : super(key: key);
  final String category;
  final String reportedID;

  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  String _description = '';
  final Timestamp timestamp = Timestamp.now();
  String reportID = const Uuid().v4();
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
            TextFormField(
              maxLines: 3,
              maxLength: 100,
              decoration: InputDecoration(
                labelText: 'Describe your problem.',
                counterText: '${_description.trim().length} / 100',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return 'Report description is required';
                }
              },
              onChanged: (value) {
                setState(() {
                  _description = value;
                });
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
                    .submitReport(
                  widget.category,
                  reportID,
                  {
                    'reported_ID': widget.reportedID,
                    'userUID': Provider.of<FirebaseOperations>(context, listen: false).getUserId,
                    'details': _description,
                    'timestamp': timestamp,
                  },
                ).whenComplete(() {
                  setState(() {
                    _isCreating = false;
                  });
                  Navigator.pop(context);
                });
              },
              buttonName: 'Submit',
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    )
        : loadingAnimation('Submitting report...');
  }
}
