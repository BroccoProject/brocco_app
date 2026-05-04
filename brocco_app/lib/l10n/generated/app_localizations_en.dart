// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get description => 'Description';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get recipe => 'Recipe';

  @override
  String get startCooking => 'Start Cooking';

  @override
  String get oopsSomethingWentWrong => 'Oops! Something went wrong';

  @override
  String get couldNotFetchRecipeDetails =>
      'Could not fetch recipe details.\nPlease check your internet connection.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get back => 'Back';

  @override
  String get swipeToDiscover => 'Swipe to discover →';

  @override
  String get categoryEmpty => 'Category empty';

  @override
  String errorWithDetail(String error) {
    return 'Error: $error';
  }

  @override
  String get done => 'DONE';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get selectDate => 'Select date';

  @override
  String get saving => 'Saving...';

  @override
  String get finishAndCalculate => 'Finish and Calculate';

  @override
  String get weightAndActivity => 'Weight and Activity';

  @override
  String get howMuchTimeForMeal => 'How much time do you have for a meal?';

  @override
  String get howOftenDoYouCook => 'How often do you cook?';

  @override
  String get whatDoYouWantToAchieve => 'What do you want to achieve?';

  @override
  String get eatHealthier => 'Eat Healthier';

  @override
  String get loseWeight => 'Lose Weight';

  @override
  String get buildMuscle => 'Build Muscle Mass';

  @override
  String get learnToCook => 'Learn to Cook';

  @override
  String get saveTime => 'Save Time';

  @override
  String get whatIsYourLevel => 'What is your current level?';

  @override
  String get levelBeginner => 'I can heat up food... and that\'s basically it.';

  @override
  String get levelIntermediate =>
      'I cook regularly and love trying new recipes.';

  @override
  String get levelAdvanced => 'Stewing and deglazing have no secrets from me.';

  @override
  String get noRecipeFallback => 'No recipe available yet';

  @override
  String get mainGoalMissing => 'Main goal is missing.';

  @override
  String get userNotLoggedIn => 'User is not logged in.';

  @override
  String get invalidHeight => 'Invalid height entered (50 - 250 cm).';

  @override
  String get birthDatePast => 'Birth date must be in the past.';

  @override
  String get basicDataHelp =>
      'Basic data will help us tailor your nutrition plan.';

  @override
  String get weightActivityDescription =>
      'This data will allow us to calculate your caloric profile.';

  @override
  String get invalidWeight => 'Invalid weight entered (20 - 300 kg).';

  @override
  String get invalidTargetWeight =>
      'Invalid target weight entered (20 - 300 kg).';

  @override
  String get lowActivity => 'Low (Sedentary work)';

  @override
  String get errorLoadingSettings => 'Error loading settings';

  @override
  String get screenAlwaysOn => 'Screen always on';

  @override
  String get dontTurnOffScreen => 'Don\'t turn off screen while cooking';

  @override
  String get beepOnTimerEnd => 'Beep on timer end';

  @override
  String get mascotSounds => 'Mascot sounds';

  @override
  String get broccoComments => 'Brocco comments on your progress';

  @override
  String get dietaryPreferences => 'Dietary preferences';

  @override
  String get dietaryPreferencesDescription =>
      'Allergies, vegetarianism and more';

  @override
  String get searchIngredientHint => 'Type an ingredient...';

  @override
  String get allergiesAvoid => 'Select allergies and ingredients you avoid.';

  @override
  String get meatLess => 'Less meat';

  @override
  String get vegetarian => 'Vegetarian';

  @override
  String get vegan => 'Vegan';

  @override
  String errorLoadingDictionaries(String error) {
    return 'Error loading dictionaries: $error';
  }

  @override
  String get kitchenSettings => 'Kitchen Settings';

  @override
  String get duringCooking => 'During Cooking';

  @override
  String get timerAlarms => 'Timer Alarms';

  @override
  String get preferences => 'Preferences';

  @override
  String get dietaryRules => 'Dietary Rules';

  @override
  String get editDiets => 'Edit Diets';

  @override
  String get account => 'Account';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get recoverProSubscriptions => 'Recover Pro Subscriptions';

  @override
  String get logOut => 'Log Out';

  @override
  String get unlockProChef => 'Unlock Pro Chef Mode';

  @override
  String get allWorldsNoLimits => 'All culinary worlds, no star limits!';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get premium => 'PREMIUM';

  @override
  String get continueText => 'Continue';

  @override
  String get onboardingStep1Subtitle =>
      'We will adapt the app and recipes to your main goal.';

  @override
  String get eatHealthierSubtitle =>
      'I want to introduce better habits to my kitchen.';

  @override
  String get loseWeightSubtitle =>
      'I need control over calories and macronutrients.';

  @override
  String get buildMuscleSubtitle => 'I care about high-protein meals.';

  @override
  String get learnToCookSubtitle =>
      'I want to learn new techniques from scratch.';

  @override
  String get saveTimeSubtitle =>
      'I\'m looking for quick and proven recipes for every day.';

  @override
  String get microwaveMaster => 'Microwave Master';

  @override
  String get homeCook => 'Home Cook';

  @override
  String get masterChef => 'Master Chef';

  @override
  String get onboardingStep2Subtitle =>
      'This will help us choose appropriately difficult recipes.';

  @override
  String get habitsAndTime => 'Habits and Time';

  @override
  String get onboardingStep3Subtitle =>
      'Tell us how often you cook and how much time you can spend.';

  @override
  String get eatEverything => 'I eat everything';

  @override
  String get fishOnly => 'Fish only';

  @override
  String get styleAndFlavors => 'Style and Flavors';

  @override
  String get onboardingStep4Subtitle =>
      'We will match recipes to your style and favorite cuisines.';

  @override
  String get eatingStyle => 'Eating Style';

  @override
  String get favoriteCuisinesOptional => 'Favorite cuisines (optional)';

  @override
  String get none => 'None';

  @override
  String get exclusions => 'Exclusions';

  @override
  String get allergiesIntolerances => 'Allergies and Intolerances';

  @override
  String get whatDoYouDislikeOptional => 'What do you dislike? (optional)';

  @override
  String get aboutYou => 'About You';

  @override
  String get other => 'Other';

  @override
  String get birthDate => 'Birth Date';

  @override
  String get heightCm => 'Height (cm)';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get targetWeightKg => 'Target Weight (kg)';

  @override
  String get profile => 'Profile';

  @override
  String get kitchen => 'Kitchen';

  @override
  String get search => 'Search';

  @override
  String get settings => 'Settings';

  @override
  String get physicalActivity => 'Physical Activity';

  @override
  String get activityLow => 'Low (Sedentary work)';

  @override
  String get activityModerate => 'Moderate (Walking, recreation)';

  @override
  String get activityHigh => 'High (Regular training)';

  @override
  String get discoverRecipes => 'Discover Recipes';

  @override
  String get searchHint => 'What are you looking for today, Chef?';

  @override
  String get filter => 'Filter';

  @override
  String get prepTime => 'Preparation Time';

  @override
  String get nameLabel => 'Name';

  @override
  String foundRecipes(int count) {
    return 'Found $count recipes';
  }

  @override
  String get filterRecipes => 'Filter Recipes';

  @override
  String get maxTimeMin => 'Maximum time (min)';

  @override
  String get difficultyLevel => 'Difficulty level';

  @override
  String get applyFilters => 'Apply filters';

  @override
  String get noLimit => 'No limit';

  @override
  String get everyday => 'Every day';

  @override
  String get fewTimesAWeek => 'A few times a week';

  @override
  String get onlyWeekends => 'Only on weekends';

  @override
  String minutesAbbr(String minutes) {
    return '$minutes min';
  }

  @override
  String get culinaryCV => 'Your Culinary CV';

  @override
  String get masterpieces => 'Your Masterpieces';

  @override
  String get chooseYourPath => 'Choose your path';

  @override
  String get noCategories => 'No categories to display.';

  @override
  String completedMealsCount(int completed, int total) {
    return '$completed/$total Completed meals';
  }

  @override
  String unlockFor(Object count) {
    return 'Unlock for $count';
  }

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get levelCompleted => 'Level completed!';

  @override
  String completedRecipeFor(String title) {
    return 'You\'ve completed the recipe for $title!';
  }

  @override
  String get rewardsToCollect => 'REWARDS TO COLLECT';

  @override
  String get experiencePoints => 'Experience Points';

  @override
  String get captureMasterpiece => 'Capture your masterpiece!';

  @override
  String get addPhotoBonus =>
      'Add a photo or video of your dish\nto earn an extra +50 XP.';

  @override
  String get claimRewardsAndFinish => 'Claim rewards and finish';

  @override
  String get nextStep => 'Ready! Next Step';

  @override
  String stepLabel(int number) {
    return 'Step $number:';
  }

  @override
  String get processingRecipe => 'Processing recipe...';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get xpAbbr => 'XP';

  @override
  String get finish => 'Finish';

  @override
  String get dataCaloricProfile =>
      'This data will allow us to calculate your caloric profile.';

  @override
  String get powerUpCooking => 'Power up your cooking';

  @override
  String get splashSubtitle =>
      'Turn daily meals into missions, earn rewards, and master your kitchen.';

  @override
  String get yourKitchenAssistant => 'Your kitchen assistant';

  @override
  String get login => 'Login';

  @override
  String get createAccount => 'Create account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get repeatPassword => 'Repeat password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get register => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get noAccountYet => 'Don\'t have an account yet? ';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String errorGeneric(Object error) {
    return 'Error: $error';
  }

  @override
  String get loginFailed => 'Login failed';

  @override
  String get userFallback => 'User';

  @override
  String xpToNextRank(int xp) {
    return '$xp / 1000 XP to next rank';
  }

  @override
  String daysStreak(int count) {
    return '$count days in a row';
  }

  @override
  String get takeProfilePhoto => 'Take a profile photo';

  @override
  String get noIngredients => 'No ingredients';

  @override
  String neededIngredients(int count) {
    return 'NEEDED INGREDIENTS ($count)';
  }

  @override
  String get allIngredientsAdded => 'All ingredients added!';

  @override
  String get tapToAdd => 'Tap to add';

  @override
  String ingredientsCount(int added, int total) {
    return '$added/$total ingredients';
  }

  @override
  String get noCompletedRecipes => 'No completed recipes';

  @override
  String get takePhotoBonusXP => 'Take a photo (+50 XP)';

  @override
  String get chooseFromGalleryBonusXP => 'Choose from gallery (+50 XP)';

  @override
  String errorLoadingRecipes(Object error) {
    return 'Error loading recipes: $error';
  }

  @override
  String get invalidEmailPassword => 'Invalid email or password.';

  @override
  String get emailAlreadyRegistered => 'This email is already registered.';

  @override
  String get noInternetConnection => 'No internet connection.';

  @override
  String get errorSavingProfile =>
      'Could not save profile. Please check your internet connection.';

  @override
  String starsCount(int count) {
    return '$count stars';
  }

  @override
  String get cookingStage => 'COOKING STAGE';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get featureInPreparation => 'Feature in preparation.';

  @override
  String get noDescription => 'No description';

  @override
  String configurationError(String detail) {
    return 'Configuration error: $detail';
  }

  @override
  String get noGoogleIdToken => 'No ID token from Google';
}
