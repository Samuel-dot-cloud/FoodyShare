import 'package:flutter/material.dart';

import 'labeled_radio.dart';

class ThemeOptions extends StatefulWidget {
  const ThemeOptions({Key? key}) : super(key: key);

  @override
  _ThemeOptionsState createState() => _ThemeOptionsState();
}

class _ThemeOptionsState extends State<ThemeOptions> {
  bool _isRadioSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabeledRadio(
          label: 'Light Theme',
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          groupValue: _isRadioSelected,
          value: true,
          onChanged: (bool newValue) {
            setState(() {
              _isRadioSelected = newValue;
            });
          },
        ),
        LabeledRadio(
          label: 'Dark Theme',
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          groupValue: _isRadioSelected,
          value: true,
          onChanged: (bool newValue) {
            setState(() {
              _isRadioSelected = newValue;
            });
          },
        ),
        LabeledRadio(
          label: 'Use System Default',
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          groupValue: _isRadioSelected,
          value: true,
          onChanged: (bool newValue) {
            setState(() {
              _isRadioSelected = newValue;
            });
          },
        ),
      ],
    );
  }
}
