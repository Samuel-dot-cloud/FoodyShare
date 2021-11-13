import 'package:flutter/material.dart';
import 'package:food_share/utils/constants.dart';
import 'package:food_share/utils/pallete.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  final List<bool> _isOpen = [true, true, true];

  ExpansionPanel _buildInfoPanel(
      {required String header,
      required String body,
      required bool isExpanded}) {
    return ExpansionPanel(
      canTapOnHeader: true,
      headerBuilder: (context, isOpen) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            header,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18.0,
            ),
          ),
        );
      },
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          body,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15.0,
            color: Colors.grey,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      isExpanded: isExpanded,
    );
  }

  ListTile _buildOptionsTile(IconData icon, String title, String subtitle, VoidCallback onTap){
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            Icons.clear,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'About',
          style: kBodyText.copyWith(
            fontSize: 25.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: false,
      ),
      bottomNavigationBar: Container(
        height: 45.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
              'Made with ❤ in Kenya with Flutter!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.0,
            color: Colors.grey[500],
          ),),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.15,
                width: size.width * 0.3,
                child: const CircleAvatar(
                  backgroundColor: kBlue,
                  backgroundImage: AssetImage(
                    'assets/icons/launcher_icon.png',
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              const Text(
                Constants.appName,
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                Constants.appDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              ExpansionPanelList(
                animationDuration: const Duration(milliseconds: 500),
                dividerColor: Colors.grey[500],
                expandedHeaderPadding: const EdgeInsets.all(8.0),
                elevation: 2.0,
                children: [
                  _buildInfoPanel(
                      header: 'Usernames',
                      body:
                          'Usernames (@) are unique identifiers that are used to ensure that each user can be securely identified with his/her own account.',
                      isExpanded: _isOpen[0]),
                  _buildInfoPanel(
                      header: 'Collections',
                      body:
                          'Through the use of collections, the app is able to place each of the recipes submitted into six distinct sections, where it is much easier for a user to find a desired recipe. \n '
                          'Thinking of finding special diet recipes? Well then, the special diet collection definitely has your back. \n '
                          'Thinking of finding recipes that utilize a specific ingredient? Well then, the ingredients collection definitely has your back. \n '
                          'The categorization of recipes is further made possible by hashtags, which enable a user to post recipes to a specific collection(s), as each collection has its own unique combination of hashtags.',
                      isExpanded: _isOpen[1]),
                  _buildInfoPanel(
                      header: 'Hashtags',
                      body:
                          'Think of hashtags as specific food categories which make finding a recipe of your liking that much easier. \n '
                          'Closer examination of hashtags will reveal that they are named after actual realistic food categories, which enables you as the user to quickly dial down on recipes of your liking. \n '
                          'Thinking of preparing christmas recipes? Well then, recipes under the #christmas tag definitely have you covered. \n '
                          'Thinking of appetizers, then recipes under the #appetizer tag definitely have your back. \n '
                              'By now you\'ve definitely gotten the gist of how hashtags work. \n '
                          'Therefore, get down to recipe sharing and use them hashtags.',
                      isExpanded: _isOpen[2]),
                ],
                expansionCallback: (i, isOpen) {
                  setState(() {
                    _isOpen[i] = !isOpen;
                  });
                },
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              _buildOptionsTile(Icons.library_books_outlined, 'App Licenses', 'Check out app library licenses.', () {
                showLicensePage(
                  context: context,
                  applicationName: Constants.appName,
                  applicationVersion: '1.0.0',
                  applicationLegalese: 'Copyright Samuel Wahome',
                  applicationIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/icons/launcher_icon.png',
                      width: 48.0,
                      height: 48.0,
                    ),
                  ),
                );
              }),
              SizedBox(
                height: size.height * 0.01,
              ),
              _buildOptionsTile(Icons.group_outlined, 'Privacy Policy', 'Read FoodyShare\'s Privacy Policy.', () {

              }),
            ],
          ),
        ),
      ),
    );
  }
}
