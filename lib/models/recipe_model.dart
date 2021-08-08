import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  String? id;
  String? title, writer, description;
  int? cookingTime;
  int? servings;
  List<String>? ingredients = [];
  List<String>? preparation = [];
  String? imgPath;
  Timestamp? createdAt;

  RecipeModel({
    required this.title,
    required this.writer,
    required this.description,
    required this.cookingTime,
    required this.servings,
    required this.ingredients,
    required this.preparation,
    required this.imgPath,
    required this.createdAt,
  });

  static List<RecipeModel> demoRecipe = [
    RecipeModel(
      title: 'Gruyère, Bacon, and Spinach Scrambled Eggs',
      writer: 'Samuel Wahome',
      description:
          'A touch of Dijon mustard, salty bacon, melty cheese and delicious goodness',
      cookingTime: 10,
      servings: 4,
      imgPath: 'assets/images/img-1.jpg',
      ingredients: [
        '8 large eggs',
        '1 tsp. Dijon mustard',
        'Kosher salt and pepper',
        '1 tbsp. olive oil or unsalted butter',
        '2 slices thick-cut bacon, cooked and broken into pieces',
        '2 c. spinach, torn',
        '2 oz. Gruyère cheese, shredded',
      ],
      preparation: [
        'In a large bowl, whisk together eggs, Dijon mustard, 1 tablespoon water and 1/2 teaspoon each salt and pepper.',
        'Heat oil or butter in 10-inch nonstick skillet on medium. Add eggs and cook, stirring with rubber spatula every few seconds, to desired doneness, 2 to 3 minutes for medium-soft eggs. Fold in bacon, spinach, and Gruyère cheese.',
      ], createdAt: Timestamp.now(),
    ),
    RecipeModel(
      title: 'Spaghetti and Air Fryer Meatballs',
      writer: 'Samuel Wahome',
      description: 'Air fryer meatballs make cleanup a breeze',
      cookingTime: 30,
      servings: 4,
      imgPath: 'assets/images/img-2.jpg',
      ingredients: [
        '2 large eggs',
        '2 tsp. balsamic vinegar',
        'Kosher salt and pepper',
        '1/3 c. panko',
        '4 large cloves garlic (2 grated and 2 chopped)',
        '1/4 c. grated Parmesan plus more for serving',
        '1/2 c. flat-leaf parsley, chopped',
        '1/2 lb. sweet Italian sausage, casings removed',
        '1/2 lb. ground beef',
        '12 oz. spaghetti',
        '1 lb. cherry tomatoes',
        '1 red chile, sliced',
        '1 tbsp. olive oil',
        '1 1/2 c. marinara sauce, warmed',
        'Fresh basil, for serving',
      ],
      preparation: [
        'In a large bowl, whisk together eggs, vinegar and 1/2 teaspoon each salt and pepper. Stir in panko and let sit 1 minute. Stir in grated garlic and Parmesan, then parsley. Add sausage and beef and gently mix to combine.',
        'Shape meat mixture into 20 balls (about 1 1/2 inches each) and place in single layer on air fryer rack (balls can touch, but should not be stacked; cook in batches if necessary). Air-fry meatballs at 400°F 5 minutes.',
        'Meanwhile, cook spaghetti per package directions.',
        'In a bowl, toss tomatoes, chile and chopped garlic with oil and 1/4 teaspoon each salt and pepper. Scatter over meatballs and continue air-frying until meatballs are cooked through, 5 to 6 minutes more.',
        'Toss meatballs and tomatoes with marinara, then gently with pasta. Serve topped with Parmesan and basil if desired.',
      ], createdAt: Timestamp.now(),
    ),
    RecipeModel(
      title: 'Mushroom and Brussels Sprouts Pizza',
      writer: 'Samuel Wahome',
      description: 'Meet the star of your next pizza night',
      cookingTime: 25,
      servings: 4,
      imgPath: 'assets/images/img-3.jpg',
      ingredients: [
        'Cornmeal, for baking sheet',
        'Flour, for surface',
        '1 lb. refrigerated (or thawed from frozen) pizza dough',
        '3 oz. fontina cheese, coarsely grated, divided',
        '4 oz. shiitake mushrooms, stems discarded, torn',
        '1 1/2 tbsp. balsamic vinegar',
        '4 large Brussels sprouts, trimmed, loose leaves separated, remaining thinly sliced',
        '1 small red onion, sliced',
        '2 tbsp. olive oil',
        'Kosher salt and pepper',
        '2 oz. fresh goat cheese',
        '6 sprigs fresh thyme',
      ],
      preparation: [
        'Heat oven to 475°F. Sprinkle baking sheet with cornmeal or line with parchment paper. On lightly floured surface, shape pizza dough into large oval. Transfer to prepared sheet and sprinkle with all but ½ cup fontina.',
        'In large bowl, toss mushrooms with balsamic vinegar. Add Brussels sprouts (whole leaves and slices) and onion, drizzle with oil and season with ½ tsp each salt and pepper. Toss to combine and scatter over dough.',
        'Sprinkle with remaining fontina, then crumble goat cheese over top and sprinkle with thyme. Bake until crust is deep golden brown and vegetables are tender, 10 to 12 min.',
      ], createdAt: Timestamp.now(),
    ),
    RecipeModel(
      title: 'Roasted Garlicky Shrimp',
      writer: 'Samuel Wahome',
      description: 'Try this one-pan delight',
      cookingTime: 20,
      servings: 4,
      imgPath: 'assets/images/img-4.jpg',
      ingredients: [
        '1 1/2 lb. large peeled and deveined shrimp',
        '1 12-ounce jar roasted red peppers, drained and cut into 1-inch pieces',
        '4 scallions, sliced',
        '2 cloves garlic, pressed',
        '2 tbsp. dry white wine',
        '1 tbsp. fresh lemon juice',
        'Kosher salt and pepper',
        '2 tbsp. olive oil',
        '4 oz. feta cheese, crumbled',
        'Pitas and baby spinach, rice or couscous, or salad greens, for serving',
      ],
      preparation: [
        'Heat oven to 425°F. In 1½- to 2-qt baking dish, combine shrimp, red peppers, scallions, garlic, wine, lemon juice and ¼ teaspoon each salt and pepper.',
        'Drizzle with olive oil and sprinkle with feta cheese. Bake until shrimp are opaque throughout, 12 to 15 minutes. Spoon into pitas along with baby spinach, serve over rice or couscous or toss with your favorite salad greens.',
      ], createdAt: Timestamp.now(),
    ),
    RecipeModel(
      title: 'Vegetable Ramen With Mushrooms and Bok Choy',
      writer: 'Samuel Wahome',
      description:
          "If Meatless Monday isn't your thing, add shredded chicken or sliced sirloin steak for extra protein.",
      cookingTime: 25,
      servings: 4,
      imgPath: 'assets/images/img-5.jpg',
      ingredients: [
        '3 scallions',
        '1 3-oz piece ginger, peeled and very thinly sliced',
        '5 tbsp. low-sodium tamari or soy sauce',
        '6 oz. ramen noodles',
        '6 oz. shiitake mushroom caps, thinly sliced',
        '2 heads baby bok choy, stems thinly sliced and leaves halved lengthwise',
        '4 oz.  snow peas, thinly sliced lengthwise',
        '1 tbsp. rice vinegar',
        '2 soft-medium boiled eggs, peeled and halved',
        '1/2 c. cilantro sprigs',
        'Thinly sliced red chile, to taste',
      ],
      preparation: [
        'Slice white parts of scallions and place in large pot with ginger and 8 cups water; bring to a boil. ',
        'Stir in tamari, then add noodles and cook per package directions, adding mushrooms and bok choy 3 minutes after adding noodles. Remove from heat and stir in snow peas and vinegar.',
        'Divide soup among 4 bowls and place 1 egg half on top of each. Slice remaining scallion greens and serve over soup along with cilantro and red chile.',
      ], createdAt: Timestamp.now(),
    ),
    RecipeModel(
      title: 'Carnitas Tacos',
      writer: 'Samuel Wahome',
      description:
          'Put your slow-cooker to good use with this spicy and savory pork tacos recipe.',
      cookingTime: 450,
      servings: 8,
      imgPath: 'assets/images/img-6.jpg',
      ingredients: [
        '1 tbsp. canola oil',
        '4 lb. boneless pork shoulder, trimmed, cut into 3 pieces',
        '2 tbsp. ground cumin',
        '1 large white onion, chopped',
        '3 poblano chiles, seeded and chopped',
        '2 serrano chiles, sliced',
        '4 cloves garlic, crushed with press',
        '1/2 c. chicken broth or water',
        '1/4 c. lime juice',
        '24 small tortillas, warmed',
        'Cilantro, sliced green onions, sliced radishes, salsa and lime wedges, for serving',
      ],
      preparation: [
        'In 12-in skillet, heat oil on medium-high until hot. Season pork all over with cumin and 1 teaspoon salt. Cook 5 minutes or until browned on two sides, turning over once halfway through. Transfer pork to slow-cooker bowl.',
        'To skillet, add onion, chiles and garlic; cook 2 minutes, stirring often. Transfer to slow cooker bowl along with broth and lime juice. Cover and cook on Low for 7 hours or until very tender.',
        'Transfer pork to cutting board; with two forks, pull into bite-size shreds, discarding any fat. Serve with tortillas and fixings.',
      ], createdAt: Timestamp.now(),
    ),
  ];

  RecipeModel.fromMap(Map<String, dynamic> data){
    id = data['id'];
    title = data['title'];
    writer = data['writer'];
    description = data['description'];
    cookingTime = data['cookingTime'];
    servings = data['servings'];
    imgPath = data['imgPath'];
    ingredients = data['ingredients'];
    preparation = data['preparation'];
    createdAt = data['createdAt'];
  }
}
