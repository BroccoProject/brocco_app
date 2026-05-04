import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Label for description tab
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Label for ingredients tab
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// Label for recipe tab
  ///
  /// In en, this message translates to:
  /// **'Recipe'**
  String get recipe;

  /// Button to start cooking
  ///
  /// In en, this message translates to:
  /// **'Start Cooking'**
  String get startCooking;

  /// Error title
  ///
  /// In en, this message translates to:
  /// **'Oops! Something went wrong'**
  String get oopsSomethingWentWrong;

  /// Error description for recipe details
  ///
  /// In en, this message translates to:
  /// **'Could not fetch recipe details.\nPlease check your internet connection.'**
  String get couldNotFetchRecipeDetails;

  /// Button to try again
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Button to go back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Hint to swipe on roadmap
  ///
  /// In en, this message translates to:
  /// **'Swipe to discover →'**
  String get swipeToDiscover;

  /// Message when a category is empty
  ///
  /// In en, this message translates to:
  /// **'Category empty'**
  String get categoryEmpty;

  /// Generic error message with detail
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorWithDetail(String error);

  /// Label for completed items
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get done;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @finishAndCalculate.
  ///
  /// In en, this message translates to:
  /// **'Finish and Calculate'**
  String get finishAndCalculate;

  /// No description provided for @weightAndActivity.
  ///
  /// In en, this message translates to:
  /// **'Weight and Activity'**
  String get weightAndActivity;

  /// No description provided for @howMuchTimeForMeal.
  ///
  /// In en, this message translates to:
  /// **'How much time do you have for a meal?'**
  String get howMuchTimeForMeal;

  /// No description provided for @howOftenDoYouCook.
  ///
  /// In en, this message translates to:
  /// **'How often do you cook?'**
  String get howOftenDoYouCook;

  /// No description provided for @whatDoYouWantToAchieve.
  ///
  /// In en, this message translates to:
  /// **'What do you want to achieve?'**
  String get whatDoYouWantToAchieve;

  /// No description provided for @eatHealthier.
  ///
  /// In en, this message translates to:
  /// **'Eat Healthier'**
  String get eatHealthier;

  /// No description provided for @loseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get loseWeight;

  /// No description provided for @buildMuscle.
  ///
  /// In en, this message translates to:
  /// **'Build Muscle Mass'**
  String get buildMuscle;

  /// No description provided for @learnToCook.
  ///
  /// In en, this message translates to:
  /// **'Learn to Cook'**
  String get learnToCook;

  /// No description provided for @saveTime.
  ///
  /// In en, this message translates to:
  /// **'Save Time'**
  String get saveTime;

  /// No description provided for @whatIsYourLevel.
  ///
  /// In en, this message translates to:
  /// **'What is your current level?'**
  String get whatIsYourLevel;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'I can heat up food... and that\'s basically it.'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'I cook regularly and love trying new recipes.'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Stewing and deglazing have no secrets from me.'**
  String get levelAdvanced;

  /// No description provided for @noRecipeFallback.
  ///
  /// In en, this message translates to:
  /// **'No recipe available yet'**
  String get noRecipeFallback;

  /// No description provided for @mainGoalMissing.
  ///
  /// In en, this message translates to:
  /// **'Main goal is missing.'**
  String get mainGoalMissing;

  /// No description provided for @userNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'User is not logged in.'**
  String get userNotLoggedIn;

  /// No description provided for @invalidHeight.
  ///
  /// In en, this message translates to:
  /// **'Invalid height entered (50 - 250 cm).'**
  String get invalidHeight;

  /// No description provided for @birthDatePast.
  ///
  /// In en, this message translates to:
  /// **'Birth date must be in the past.'**
  String get birthDatePast;

  /// No description provided for @basicDataHelp.
  ///
  /// In en, this message translates to:
  /// **'Basic data will help us tailor your nutrition plan.'**
  String get basicDataHelp;

  /// No description provided for @weightActivityDescription.
  ///
  /// In en, this message translates to:
  /// **'This data will allow us to calculate your caloric profile.'**
  String get weightActivityDescription;

  /// No description provided for @invalidWeight.
  ///
  /// In en, this message translates to:
  /// **'Invalid weight entered (20 - 300 kg).'**
  String get invalidWeight;

  /// No description provided for @invalidTargetWeight.
  ///
  /// In en, this message translates to:
  /// **'Invalid target weight entered (20 - 300 kg).'**
  String get invalidTargetWeight;

  /// No description provided for @lowActivity.
  ///
  /// In en, this message translates to:
  /// **'Low (Sedentary work)'**
  String get lowActivity;

  /// No description provided for @errorLoadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error loading settings'**
  String get errorLoadingSettings;

  /// No description provided for @screenAlwaysOn.
  ///
  /// In en, this message translates to:
  /// **'Screen always on'**
  String get screenAlwaysOn;

  /// No description provided for @dontTurnOffScreen.
  ///
  /// In en, this message translates to:
  /// **'Don\'t turn off screen while cooking'**
  String get dontTurnOffScreen;

  /// No description provided for @beepOnTimerEnd.
  ///
  /// In en, this message translates to:
  /// **'Beep on timer end'**
  String get beepOnTimerEnd;

  /// No description provided for @mascotSounds.
  ///
  /// In en, this message translates to:
  /// **'Mascot sounds'**
  String get mascotSounds;

  /// No description provided for @broccoComments.
  ///
  /// In en, this message translates to:
  /// **'Brocco comments on your progress'**
  String get broccoComments;

  /// No description provided for @dietaryPreferences.
  ///
  /// In en, this message translates to:
  /// **'Dietary preferences'**
  String get dietaryPreferences;

  /// No description provided for @dietaryPreferencesDescription.
  ///
  /// In en, this message translates to:
  /// **'Allergies, vegetarianism and more'**
  String get dietaryPreferencesDescription;

  /// No description provided for @searchIngredientHint.
  ///
  /// In en, this message translates to:
  /// **'Type an ingredient...'**
  String get searchIngredientHint;

  /// No description provided for @allergiesAvoid.
  ///
  /// In en, this message translates to:
  /// **'Select allergies and ingredients you avoid.'**
  String get allergiesAvoid;

  /// No description provided for @meatLess.
  ///
  /// In en, this message translates to:
  /// **'Less meat'**
  String get meatLess;

  /// No description provided for @vegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get vegetarian;

  /// No description provided for @vegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get vegan;

  /// No description provided for @errorLoadingDictionaries.
  ///
  /// In en, this message translates to:
  /// **'Error loading dictionaries: {error}'**
  String errorLoadingDictionaries(String error);

  /// No description provided for @kitchenSettings.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Settings'**
  String get kitchenSettings;

  /// No description provided for @duringCooking.
  ///
  /// In en, this message translates to:
  /// **'During Cooking'**
  String get duringCooking;

  /// No description provided for @timerAlarms.
  ///
  /// In en, this message translates to:
  /// **'Timer Alarms'**
  String get timerAlarms;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @dietaryRules.
  ///
  /// In en, this message translates to:
  /// **'Dietary Rules'**
  String get dietaryRules;

  /// No description provided for @editDiets.
  ///
  /// In en, this message translates to:
  /// **'Edit Diets'**
  String get editDiets;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @recoverProSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Recover Pro Subscriptions'**
  String get recoverProSubscriptions;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @unlockProChef.
  ///
  /// In en, this message translates to:
  /// **'Unlock Pro Chef Mode'**
  String get unlockProChef;

  /// No description provided for @allWorldsNoLimits.
  ///
  /// In en, this message translates to:
  /// **'All culinary worlds, no star limits!'**
  String get allWorldsNoLimits;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get premium;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @onboardingStep1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'We will adapt the app and recipes to your main goal.'**
  String get onboardingStep1Subtitle;

  /// No description provided for @eatHealthierSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I want to introduce better habits to my kitchen.'**
  String get eatHealthierSubtitle;

  /// No description provided for @loseWeightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I need control over calories and macronutrients.'**
  String get loseWeightSubtitle;

  /// No description provided for @buildMuscleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I care about high-protein meals.'**
  String get buildMuscleSubtitle;

  /// No description provided for @learnToCookSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I want to learn new techniques from scratch.'**
  String get learnToCookSubtitle;

  /// No description provided for @saveTimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'I\'m looking for quick and proven recipes for every day.'**
  String get saveTimeSubtitle;

  /// No description provided for @microwaveMaster.
  ///
  /// In en, this message translates to:
  /// **'Microwave Master'**
  String get microwaveMaster;

  /// No description provided for @homeCook.
  ///
  /// In en, this message translates to:
  /// **'Home Cook'**
  String get homeCook;

  /// No description provided for @masterChef.
  ///
  /// In en, this message translates to:
  /// **'Master Chef'**
  String get masterChef;

  /// No description provided for @onboardingStep2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'This will help us choose appropriately difficult recipes.'**
  String get onboardingStep2Subtitle;

  /// No description provided for @habitsAndTime.
  ///
  /// In en, this message translates to:
  /// **'Habits and Time'**
  String get habitsAndTime;

  /// No description provided for @onboardingStep3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us how often you cook and how much time you can spend.'**
  String get onboardingStep3Subtitle;

  /// No description provided for @eatEverything.
  ///
  /// In en, this message translates to:
  /// **'I eat everything'**
  String get eatEverything;

  /// No description provided for @fishOnly.
  ///
  /// In en, this message translates to:
  /// **'Fish only'**
  String get fishOnly;

  /// No description provided for @styleAndFlavors.
  ///
  /// In en, this message translates to:
  /// **'Style and Flavors'**
  String get styleAndFlavors;

  /// No description provided for @onboardingStep4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'We will match recipes to your style and favorite cuisines.'**
  String get onboardingStep4Subtitle;

  /// No description provided for @eatingStyle.
  ///
  /// In en, this message translates to:
  /// **'Eating Style'**
  String get eatingStyle;

  /// No description provided for @favoriteCuisinesOptional.
  ///
  /// In en, this message translates to:
  /// **'Favorite cuisines (optional)'**
  String get favoriteCuisinesOptional;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @exclusions.
  ///
  /// In en, this message translates to:
  /// **'Exclusions'**
  String get exclusions;

  /// No description provided for @allergiesIntolerances.
  ///
  /// In en, this message translates to:
  /// **'Allergies and Intolerances'**
  String get allergiesIntolerances;

  /// No description provided for @whatDoYouDislikeOptional.
  ///
  /// In en, this message translates to:
  /// **'What do you dislike? (optional)'**
  String get whatDoYouDislikeOptional;

  /// No description provided for @aboutYou.
  ///
  /// In en, this message translates to:
  /// **'About You'**
  String get aboutYou;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Birth Date'**
  String get birthDate;

  /// No description provided for @heightCm.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get heightCm;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @targetWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Target Weight (kg)'**
  String get targetWeightKg;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @kitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get kitchen;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @physicalActivity.
  ///
  /// In en, this message translates to:
  /// **'Physical Activity'**
  String get physicalActivity;

  /// No description provided for @activityLow.
  ///
  /// In en, this message translates to:
  /// **'Low (Sedentary work)'**
  String get activityLow;

  /// No description provided for @activityModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate (Walking, recreation)'**
  String get activityModerate;

  /// No description provided for @activityHigh.
  ///
  /// In en, this message translates to:
  /// **'High (Regular training)'**
  String get activityHigh;

  /// No description provided for @discoverRecipes.
  ///
  /// In en, this message translates to:
  /// **'Discover Recipes'**
  String get discoverRecipes;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'What are you looking for today, Chef?'**
  String get searchHint;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @prepTime.
  ///
  /// In en, this message translates to:
  /// **'Preparation Time'**
  String get prepTime;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @foundRecipes.
  ///
  /// In en, this message translates to:
  /// **'Found {count} recipes'**
  String foundRecipes(int count);

  /// No description provided for @filterRecipes.
  ///
  /// In en, this message translates to:
  /// **'Filter Recipes'**
  String get filterRecipes;

  /// No description provided for @maxTimeMin.
  ///
  /// In en, this message translates to:
  /// **'Maximum time (min)'**
  String get maxTimeMin;

  /// No description provided for @difficultyLevel.
  ///
  /// In en, this message translates to:
  /// **'Difficulty level'**
  String get difficultyLevel;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get applyFilters;

  /// No description provided for @noLimit.
  ///
  /// In en, this message translates to:
  /// **'No limit'**
  String get noLimit;

  /// No description provided for @everyday.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyday;

  /// No description provided for @fewTimesAWeek.
  ///
  /// In en, this message translates to:
  /// **'A few times a week'**
  String get fewTimesAWeek;

  /// No description provided for @onlyWeekends.
  ///
  /// In en, this message translates to:
  /// **'Only on weekends'**
  String get onlyWeekends;

  /// No description provided for @minutesAbbr.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesAbbr(String minutes);

  /// No description provided for @culinaryCV.
  ///
  /// In en, this message translates to:
  /// **'Your Culinary CV'**
  String get culinaryCV;

  /// No description provided for @masterpieces.
  ///
  /// In en, this message translates to:
  /// **'Your Masterpieces'**
  String get masterpieces;

  /// No description provided for @chooseYourPath.
  ///
  /// In en, this message translates to:
  /// **'Choose your path'**
  String get chooseYourPath;

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories to display.'**
  String get noCategories;

  /// No description provided for @completedMealsCount.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} Completed meals'**
  String completedMealsCount(int completed, int total);

  /// No description provided for @unlockFor.
  ///
  /// In en, this message translates to:
  /// **'Unlock for {count}'**
  String unlockFor(Object count);

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @levelCompleted.
  ///
  /// In en, this message translates to:
  /// **'Level completed!'**
  String get levelCompleted;

  /// No description provided for @completedRecipeFor.
  ///
  /// In en, this message translates to:
  /// **'You\'ve completed the recipe for {title}!'**
  String completedRecipeFor(String title);

  /// No description provided for @rewardsToCollect.
  ///
  /// In en, this message translates to:
  /// **'REWARDS TO COLLECT'**
  String get rewardsToCollect;

  /// No description provided for @experiencePoints.
  ///
  /// In en, this message translates to:
  /// **'Experience Points'**
  String get experiencePoints;

  /// No description provided for @captureMasterpiece.
  ///
  /// In en, this message translates to:
  /// **'Capture your masterpiece!'**
  String get captureMasterpiece;

  /// No description provided for @addPhotoBonus.
  ///
  /// In en, this message translates to:
  /// **'Add a photo or video of your dish\nto earn an extra +50 XP.'**
  String get addPhotoBonus;

  /// No description provided for @claimRewardsAndFinish.
  ///
  /// In en, this message translates to:
  /// **'Claim rewards and finish'**
  String get claimRewardsAndFinish;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Ready! Next Step'**
  String get nextStep;

  /// No description provided for @stepLabel.
  ///
  /// In en, this message translates to:
  /// **'Step {number}:'**
  String stepLabel(int number);

  /// No description provided for @processingRecipe.
  ///
  /// In en, this message translates to:
  /// **'Processing recipe...'**
  String get processingRecipe;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @xpAbbr.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get xpAbbr;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @dataCaloricProfile.
  ///
  /// In en, this message translates to:
  /// **'This data will allow us to calculate your caloric profile.'**
  String get dataCaloricProfile;

  /// No description provided for @powerUpCooking.
  ///
  /// In en, this message translates to:
  /// **'Power up your cooking'**
  String get powerUpCooking;

  /// No description provided for @splashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn daily meals into missions, earn rewards, and master your kitchen.'**
  String get splashSubtitle;

  /// No description provided for @yourKitchenAssistant.
  ///
  /// In en, this message translates to:
  /// **'Your kitchen assistant'**
  String get yourKitchenAssistant;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @repeatPassword.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get repeatPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @noAccountYet.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account yet? '**
  String get noAccountYet;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorGeneric(Object error);

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @userFallback.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userFallback;

  /// No description provided for @xpToNextRank.
  ///
  /// In en, this message translates to:
  /// **'{xp} / 1000 XP to next rank'**
  String xpToNextRank(int xp);

  /// No description provided for @daysStreak.
  ///
  /// In en, this message translates to:
  /// **'{count} days in a row'**
  String daysStreak(int count);

  /// No description provided for @takeProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a profile photo'**
  String get takeProfilePhoto;

  /// No description provided for @noIngredients.
  ///
  /// In en, this message translates to:
  /// **'No ingredients'**
  String get noIngredients;

  /// No description provided for @neededIngredients.
  ///
  /// In en, this message translates to:
  /// **'NEEDED INGREDIENTS ({count})'**
  String neededIngredients(int count);

  /// No description provided for @allIngredientsAdded.
  ///
  /// In en, this message translates to:
  /// **'All ingredients added!'**
  String get allIngredientsAdded;

  /// No description provided for @tapToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap to add'**
  String get tapToAdd;

  /// No description provided for @ingredientsCount.
  ///
  /// In en, this message translates to:
  /// **'{added}/{total} ingredients'**
  String ingredientsCount(int added, int total);

  /// No description provided for @noCompletedRecipes.
  ///
  /// In en, this message translates to:
  /// **'No completed recipes'**
  String get noCompletedRecipes;

  /// No description provided for @takePhotoBonusXP.
  ///
  /// In en, this message translates to:
  /// **'Take a photo (+50 XP)'**
  String get takePhotoBonusXP;

  /// No description provided for @chooseFromGalleryBonusXP.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery (+50 XP)'**
  String get chooseFromGalleryBonusXP;

  /// No description provided for @errorLoadingRecipes.
  ///
  /// In en, this message translates to:
  /// **'Error loading recipes: {error}'**
  String errorLoadingRecipes(Object error);

  /// No description provided for @invalidEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password.'**
  String get invalidEmailPassword;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get emailAlreadyRegistered;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get noInternetConnection;

  /// No description provided for @errorSavingProfile.
  ///
  /// In en, this message translates to:
  /// **'Could not save profile. Please check your internet connection.'**
  String get errorSavingProfile;

  /// No description provided for @starsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} stars'**
  String starsCount(int count);

  /// No description provided for @cookingStage.
  ///
  /// In en, this message translates to:
  /// **'COOKING STAGE'**
  String get cookingStage;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @featureInPreparation.
  ///
  /// In en, this message translates to:
  /// **'Feature in preparation.'**
  String get featureInPreparation;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// No description provided for @configurationError.
  ///
  /// In en, this message translates to:
  /// **'Configuration error: {detail}'**
  String configurationError(String detail);

  /// No description provided for @noGoogleIdToken.
  ///
  /// In en, this message translates to:
  /// **'No ID token from Google'**
  String get noGoogleIdToken;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
