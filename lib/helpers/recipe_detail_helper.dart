import 'package:flutter/material.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/recipe/create_list_form.dart';
import 'package:food_share/widgets/recipe/lists_selection_view.dart';
import 'package:food_share/widgets/report_form.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailHelper with ChangeNotifier {
  showFavoriteListsBottomSheet(BuildContext context, String postID) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          ),
        ),
        builder: (context) {
          return SizedBox(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      top: 20.0,
                    ),
                    child: Text(
                      'Save to',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0, top: 20.0),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: kBlue,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: 0.3,
                  height: 0.5,
                  color: Colors.grey[500],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  left: 18.0,
                ),
                child: InkWell(
                  onTap: () => createListBottomSheetForm(context),
                  child: const Text(
                    'Create a new list...',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: kBlue,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Divider(
                  thickness: 0.3,
                  height: 0.5,
                  color: Colors.grey[500],
                ),
              ),
              Expanded(
                  child: ListsSelectionView(
                postID: postID,
              ))
            ],
          ));
        });
  }

  Future<void> createListBottomSheetForm(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          ),
        ),
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Create list',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15.0,
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Divider(
                    thickness: 0.3,
                    height: 0.5,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const CreateListForm(),
              ],
            ),
          );
        });
  }

  Future<void> showReportDialog(BuildContext context, String recipeID) async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            elevation: 15.0,
            child: SizedBox(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Center(
                    child: Text(
                        'What would you like to report?',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      thickness: 0.3,
                      height: 0.5,
                      color: Colors.grey[500],
                    ),
                  ),
                  buildRow(context, Icons.title_outlined, 'Recipe title', 'recipe', recipeID),
                  buildRow(context, Icons.breakfast_dining_outlined, 'Ingredients', 'recipe', recipeID),
                  buildRow(context, Icons.image_outlined, 'Recipe image', 'recipe', recipeID),
                  buildRow(context, Icons.article_outlined, 'Preparation', 'recipe', recipeID),
                  buildRow(context, Icons.copyright_outlined, 'Copyright infringement', 'recipe', recipeID),
                  buildRow(context, Icons.info_outline, 'Reference', 'recipe', recipeID),
                ],
              ),
            ),
          );
        });
  }

  Widget buildRow(BuildContext context, IconData icon, String text, String category, String reportedID) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: (){
          createReportBottomSheetForm(context, category, reportedID);
        },
        child: Row(
          children: [
            Icon(
              icon,
              size: 30.0,
              color: kBlue,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontSize: 17.0,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createReportBottomSheetForm(BuildContext context, String category, String reportedID) async {
    await showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15.0),
          ),
        ),
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Report form',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15.0,
                    left: 10.0,
                    right: 10.0,
                  ),
                  child: Divider(
                    thickness: 0.3,
                    height: 0.5,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ReportForm(category: category, reportedID: reportedID),
              ],
            ),
          );
        });
  }

  Future launchEmail(
      {required String email,
      required String subject,
      required String message}) async {
    final url =
        'mailto:$email?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';

    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
