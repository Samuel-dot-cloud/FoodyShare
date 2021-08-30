class OnboardingModel {
  String image = '';
  String text = '';
  String title = '';

  OnboardingModel(
      {required this.image, required this.text, required this.title});

  static List<OnboardingModel> list = [
    OnboardingModel(
      image: 'assets/images/recipes.png',
      title: 'Discover',
      text:
          'You get to have access to a wide variety of recipes in various food categories, hence making cooking your favorite meal become a bit easier, as you only need to follow the steps provided.',
    ),
    OnboardingModel(
      image: 'assets/images/curate.png',
      title: 'Curate',
      text:
      'You have the opportunity to easily curate and share your favorite recipes, making it easily available to all those who would wish to try it out.',
    ),
    OnboardingModel(
      image: 'assets/images/community.png',
      title: 'Community',
      text:
      'Get to join the many other food lovers on this platform, and proceed to follow and interact with creators of the recipes that you love.',
    ),
  ];
}
