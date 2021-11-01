import 'package:flutter/material.dart';
import 'package:food_share/utils/pallete.dart';
import 'package:food_share/widgets/recipe/create_list_form.dart';
import 'package:food_share/widgets/recipe/lists_selection_view.dart';

class RecipeDetailHelper with ChangeNotifier {

  showFavoriteListsBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
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
                children: const [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20.0,
                      top: 20.0,
                    ),
                    child: Text(
                      'Save to',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20.0, top: 20.0),
                    child: InkWell(
                      child: Text(
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
              const Expanded(child: ListsSelectionView())
            ],
          ));
        });
  }

  createListBottomSheetForm(BuildContext context) {
    showModalBottomSheet(
        context: context,
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
}
