import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageUzbek.
  ///
  /// In en, this message translates to:
  /// **'Uzbek'**
  String get languageUzbek;

  /// No description provided for @languageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Someone'**
  String get profileFallbackName;

  /// No description provided for @profileFallbackEmail.
  ///
  /// In en, this message translates to:
  /// **'someone@email.com'**
  String get profileFallbackEmail;

  /// No description provided for @premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @statWatched.
  ///
  /// In en, this message translates to:
  /// **'Watched'**
  String get statWatched;

  /// No description provided for @statWatchlist.
  ///
  /// In en, this message translates to:
  /// **'Watchlist'**
  String get statWatchlist;

  /// No description provided for @statLiked.
  ///
  /// In en, this message translates to:
  /// **'Liked'**
  String get statLiked;

  /// No description provided for @sectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get sectionAccount;

  /// No description provided for @sectionSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get sectionSupport;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacyAndSecurity;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout failed. Please try again.'**
  String get logoutFailed;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to continue watching.'**
  String get logoutConfirmMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load Privacy Policy'**
  String get privacyPolicyLoadFailed;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountConfirmTitle;

  /// No description provided for @deleteAccountConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account will be scheduled for deletion and permanently removed after 30 days. You can restore it any time within these 30 days by simply signing in again.'**
  String get deleteAccountConfirmMessage;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again.'**
  String get deleteAccountFailed;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Eshmatjon Toshmatov'**
  String get fullNameHint;

  /// No description provided for @fullNameError.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameError;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'+998901234567'**
  String get phoneHint;

  /// No description provided for @phoneError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone'**
  String get phoneError;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @selectDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Select date of birth'**
  String get selectDateOfBirth;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload photo'**
  String get uploadPhoto;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @profileUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile'**
  String get profileUpdateFailed;

  /// No description provided for @pickImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image'**
  String get pickImageFailed;

  /// No description provided for @myLibrary.
  ///
  /// In en, this message translates to:
  /// **'My Library'**
  String get myLibrary;

  /// No description provided for @myMovies.
  ///
  /// In en, this message translates to:
  /// **'My Movies'**
  String get myMovies;

  /// No description provided for @myMoviesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Movies you created'**
  String get myMoviesSubtitle;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @savedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Movies and episodes you bookmarked'**
  String get savedSubtitle;

  /// No description provided for @likedEpisodes.
  ///
  /// In en, this message translates to:
  /// **'Liked Episodes'**
  String get likedEpisodes;

  /// No description provided for @likedEpisodesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Episodes you liked'**
  String get likedEpisodesSubtitle;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @archivedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Movies and episodes you archived'**
  String get archivedSubtitle;

  /// No description provided for @tabMovies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get tabMovies;

  /// No description provided for @tabEpisodes.
  ///
  /// In en, this message translates to:
  /// **'Episodes'**
  String get tabEpisodes;

  /// No description provided for @moviesBy.
  ///
  /// In en, this message translates to:
  /// **'Movies by {name}'**
  String moviesBy(String name);

  /// No description provided for @notifLikedYourEpisode.
  ///
  /// In en, this message translates to:
  /// **'{name} liked your episode'**
  String notifLikedYourEpisode(String name);

  /// No description provided for @notifCommentedOnYourEpisode.
  ///
  /// In en, this message translates to:
  /// **'{name} commented on your episode'**
  String notifCommentedOnYourEpisode(String name);

  /// No description provided for @notifInteractedWithYou.
  ///
  /// In en, this message translates to:
  /// **'{name} interacted with your content'**
  String notifInteractedWithYou(String name);

  /// No description provided for @noMoviesYet.
  ///
  /// In en, this message translates to:
  /// **'No movies yet'**
  String get noMoviesYet;

  /// No description provided for @noMoviesCreatedYet.
  ///
  /// In en, this message translates to:
  /// **'No movies created yet'**
  String get noMoviesCreatedYet;

  /// No description provided for @failedToLoadMovies.
  ///
  /// In en, this message translates to:
  /// **'Failed to load movies'**
  String get failedToLoadMovies;

  /// No description provided for @failedToLoadYourMovies.
  ///
  /// In en, this message translates to:
  /// **'Failed to load your movies'**
  String get failedToLoadYourMovies;

  /// No description provided for @failedToLoadLikedEpisodes.
  ///
  /// In en, this message translates to:
  /// **'Failed to load liked episodes'**
  String get failedToLoadLikedEpisodes;

  /// No description provided for @noLikedEpisodesYet.
  ///
  /// In en, this message translates to:
  /// **'No liked episodes yet'**
  String get noLikedEpisodesYet;

  /// No description provided for @failedToLoadSavedMovies.
  ///
  /// In en, this message translates to:
  /// **'Failed to load saved movies'**
  String get failedToLoadSavedMovies;

  /// No description provided for @noSavedMoviesYet.
  ///
  /// In en, this message translates to:
  /// **'No saved movies yet'**
  String get noSavedMoviesYet;

  /// No description provided for @failedToLoadSavedEpisodes.
  ///
  /// In en, this message translates to:
  /// **'Failed to load saved episodes'**
  String get failedToLoadSavedEpisodes;

  /// No description provided for @noSavedEpisodesYet.
  ///
  /// In en, this message translates to:
  /// **'No saved episodes yet'**
  String get noSavedEpisodesYet;

  /// No description provided for @failedToLoadArchivedMovies.
  ///
  /// In en, this message translates to:
  /// **'Failed to load archived movies'**
  String get failedToLoadArchivedMovies;

  /// No description provided for @noArchivedMovies.
  ///
  /// In en, this message translates to:
  /// **'No archived movies'**
  String get noArchivedMovies;

  /// No description provided for @failedToLoadArchivedEpisodes.
  ///
  /// In en, this message translates to:
  /// **'Failed to load archived episodes'**
  String get failedToLoadArchivedEpisodes;

  /// No description provided for @noArchivedEpisodes.
  ///
  /// In en, this message translates to:
  /// **'No archived episodes'**
  String get noArchivedEpisodes;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @whatDoYouWantToPost.
  ///
  /// In en, this message translates to:
  /// **'What do you want to post?'**
  String get whatDoYouWantToPost;

  /// No description provided for @movie.
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get movie;

  /// No description provided for @movieActionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new movie with details'**
  String get movieActionSubtitle;

  /// No description provided for @episode.
  ///
  /// In en, this message translates to:
  /// **'Episode'**
  String get episode;

  /// No description provided for @episodeActionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload an episode to an existing movie'**
  String get episodeActionSubtitle;

  /// No description provided for @postMovie.
  ///
  /// In en, this message translates to:
  /// **'Post Movie'**
  String get postMovie;

  /// No description provided for @postEpisode.
  ///
  /// In en, this message translates to:
  /// **'Post Episode'**
  String get postEpisode;

  /// No description provided for @fieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldTitle;

  /// No description provided for @fieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get fieldDescription;

  /// No description provided for @titleHintMovie.
  ///
  /// In en, this message translates to:
  /// **'ex: The Dark Knight'**
  String get titleHintMovie;

  /// No description provided for @descriptionHintMovie.
  ///
  /// In en, this message translates to:
  /// **'ex: Crime in Gotham is at its peak. Bruce Wayne becomes a dark vigilante to protect the city'**
  String get descriptionHintMovie;

  /// No description provided for @titleHintEpisode.
  ///
  /// In en, this message translates to:
  /// **'ex: A New Beginning'**
  String get titleHintEpisode;

  /// No description provided for @descriptionHintEpisode.
  ///
  /// In en, this message translates to:
  /// **'ex: The hero arrives in a new city and faces an unexpected enemy'**
  String get descriptionHintEpisode;

  /// No description provided for @releaseYear.
  ///
  /// In en, this message translates to:
  /// **'Release Year'**
  String get releaseYear;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @selectCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategoryTitle;

  /// No description provided for @selectAgeLimit.
  ///
  /// In en, this message translates to:
  /// **'Select age limit'**
  String get selectAgeLimit;

  /// No description provided for @selectAgeLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Age Limit'**
  String get selectAgeLimitTitle;

  /// No description provided for @selectMovie.
  ///
  /// In en, this message translates to:
  /// **'Select movie'**
  String get selectMovie;

  /// No description provided for @selectMovieTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Movie'**
  String get selectMovieTitle;

  /// No description provided for @noMoviesFoundCreateFirst.
  ///
  /// In en, this message translates to:
  /// **'No movies found. Create a movie first.'**
  String get noMoviesFoundCreateFirst;

  /// No description provided for @season.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get season;

  /// No description provided for @episodeNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Episode №'**
  String get episodeNumberLabel;

  /// No description provided for @pickImage.
  ///
  /// In en, this message translates to:
  /// **'Pick Image'**
  String get pickImage;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'Change Image'**
  String get changeImage;

  /// No description provided for @pickVideo.
  ///
  /// In en, this message translates to:
  /// **'Pick Video'**
  String get pickVideo;

  /// No description provided for @changeVideo.
  ///
  /// In en, this message translates to:
  /// **'Change Video'**
  String get changeVideo;

  /// No description provided for @uploadingPercent.
  ///
  /// In en, this message translates to:
  /// **'Uploading {percent}%'**
  String uploadingPercent(String percent);

  /// No description provided for @failedToLoadCategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories'**
  String get failedToLoadCategories;

  /// No description provided for @pickVideoFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to pick video'**
  String get pickVideoFailed;

  /// No description provided for @moviePostedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Movie posted successfully'**
  String get moviePostedSuccessfully;

  /// No description provided for @episodePostedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Episode posted successfully'**
  String get episodePostedSuccessfully;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @shorts.
  ///
  /// In en, this message translates to:
  /// **'Shorts'**
  String get shorts;

  /// No description provided for @failedToLoadShorts.
  ///
  /// In en, this message translates to:
  /// **'Failed to load shorts'**
  String get failedToLoadShorts;

  /// No description provided for @noShortsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No shorts available'**
  String get noShortsAvailable;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @noCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get noCommentsYet;

  /// No description provided for @beFirstToComment.
  ///
  /// In en, this message translates to:
  /// **'Be the first to comment'**
  String get beFirstToComment;

  /// No description provided for @addAComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get addAComment;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get justNow;

  /// No description provided for @minutesAgoShort.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgoShort(int count);

  /// No description provided for @hoursAgoShort.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgoShort(int count);

  /// No description provided for @daysAgoShort.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgoShort(int count);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPost.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get navPost;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, '**
  String get hello;

  /// No description provided for @fallbackGreetingName.
  ///
  /// In en, this message translates to:
  /// **'there'**
  String get fallbackGreetingName;

  /// No description provided for @whatAreYouWatchingToday.
  ///
  /// In en, this message translates to:
  /// **'What are you watching today?'**
  String get whatAreYouWatchingToday;

  /// No description provided for @searchMoviesHint.
  ///
  /// In en, this message translates to:
  /// **'Search movies, series, genres…'**
  String get searchMoviesHint;

  /// No description provided for @featuredToday.
  ///
  /// In en, this message translates to:
  /// **'Last Added'**
  String get featuredToday;

  /// No description provided for @popularOnShortflix.
  ///
  /// In en, this message translates to:
  /// **'Popular on 916TV'**
  String get popularOnShortflix;

  /// No description provided for @browseByGenre.
  ///
  /// In en, this message translates to:
  /// **'Browse by Genre'**
  String get browseByGenre;

  /// No description provided for @noMoviesFound.
  ///
  /// In en, this message translates to:
  /// **'No movies found'**
  String get noMoviesFound;

  /// No description provided for @searchResultsCount.
  ///
  /// In en, this message translates to:
  /// **'Search Results ({count})'**
  String searchResultsCount(int count);

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @seasonEpisodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Season {season}  ·  Episode {episode}'**
  String seasonEpisodeLabel(int season, int episode);

  /// No description provided for @episodeN.
  ///
  /// In en, this message translates to:
  /// **'Episode {number}'**
  String episodeN(int number);

  /// No description provided for @seasonShort.
  ///
  /// In en, this message translates to:
  /// **'S{number}'**
  String seasonShort(int number);

  /// No description provided for @failedToLoadEpisodes.
  ///
  /// In en, this message translates to:
  /// **'Failed to load episodes'**
  String get failedToLoadEpisodes;

  /// No description provided for @noEpisodesForSeason.
  ///
  /// In en, this message translates to:
  /// **'No episodes for this season'**
  String get noEpisodesForSeason;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @yourRating.
  ///
  /// In en, this message translates to:
  /// **'Your rating'**
  String get yourRating;

  /// No description provided for @rateThisMovie.
  ///
  /// In en, this message translates to:
  /// **'Rate this movie'**
  String get rateThisMovie;

  /// No description provided for @creatorLabel.
  ///
  /// In en, this message translates to:
  /// **'Creator: '**
  String get creatorLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @emailError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get emailError;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordError;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue watching'**
  String get signInSubtitle;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @incorrectEmailOrPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get incorrectEmailOrPassword;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed. Please try again.'**
  String get googleSignInFailed;

  /// No description provided for @appleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Apple sign-in failed. Please try again.'**
  String get appleSignInFailed;

  /// No description provided for @createAccountHeading.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountHeading;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join millions watching on 916TV'**
  String get createAccountSubtitle;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @signUpFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign up failed. Please try again.'**
  String get signUpFailed;

  /// No description provided for @fullNameHintSignUp.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get fullNameHintSignUp;

  /// No description provided for @checkYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkYourEmail;

  /// No description provided for @sentCodeTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to '**
  String get sentCodeTo;

  /// No description provided for @yourEmailFallback.
  ///
  /// In en, this message translates to:
  /// **'your email'**
  String get yourEmailFallback;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get didntReceiveCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid code. Please try again.'**
  String get invalidCode;

  /// No description provided for @codeResent.
  ///
  /// In en, this message translates to:
  /// **'Code resent!'**
  String get codeResent;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Watch. Discover. Enjoy.'**
  String get appTagline;

  /// No description provided for @noConnection.
  ///
  /// In en, this message translates to:
  /// **'No Connection'**
  String get noConnection;

  /// No description provided for @checkInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get checkInternetConnection;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @editMovie.
  ///
  /// In en, this message translates to:
  /// **'Edit Movie'**
  String get editMovie;

  /// No description provided for @editEpisode.
  ///
  /// In en, this message translates to:
  /// **'Edit Episode'**
  String get editEpisode;

  /// No description provided for @updateMovie.
  ///
  /// In en, this message translates to:
  /// **'Update Movie'**
  String get updateMovie;

  /// No description provided for @updateEpisode.
  ///
  /// In en, this message translates to:
  /// **'Update Episode'**
  String get updateEpisode;

  /// No description provided for @archiveMovie.
  ///
  /// In en, this message translates to:
  /// **'Archive Movie'**
  String get archiveMovie;

  /// No description provided for @archiveEpisode.
  ///
  /// In en, this message translates to:
  /// **'Archive Episode'**
  String get archiveEpisode;

  /// No description provided for @deleteMovie.
  ///
  /// In en, this message translates to:
  /// **'Delete Movie'**
  String get deleteMovie;

  /// No description provided for @deleteEpisode.
  ///
  /// In en, this message translates to:
  /// **'Delete Episode'**
  String get deleteEpisode;

  /// No description provided for @movieUpdated.
  ///
  /// In en, this message translates to:
  /// **'Movie updated'**
  String get movieUpdated;

  /// No description provided for @failedToUpdateMovie.
  ///
  /// In en, this message translates to:
  /// **'Failed to update movie'**
  String get failedToUpdateMovie;

  /// No description provided for @episodeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Episode updated'**
  String get episodeUpdated;

  /// No description provided for @failedToUpdateEpisode.
  ///
  /// In en, this message translates to:
  /// **'Failed to update episode'**
  String get failedToUpdateEpisode;

  /// No description provided for @movieDeleted.
  ///
  /// In en, this message translates to:
  /// **'Movie deleted'**
  String get movieDeleted;

  /// No description provided for @failedToDeleteMovie.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete movie'**
  String get failedToDeleteMovie;

  /// No description provided for @episodeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Episode deleted'**
  String get episodeDeleted;

  /// No description provided for @failedToDeleteEpisode.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete episode'**
  String get failedToDeleteEpisode;

  /// No description provided for @movieArchived.
  ///
  /// In en, this message translates to:
  /// **'Movie archived'**
  String get movieArchived;

  /// No description provided for @failedToArchiveMovie.
  ///
  /// In en, this message translates to:
  /// **'Failed to archive movie'**
  String get failedToArchiveMovie;

  /// No description provided for @episodeArchived.
  ///
  /// In en, this message translates to:
  /// **'Episode archived'**
  String get episodeArchived;

  /// No description provided for @failedToArchiveEpisode.
  ///
  /// In en, this message translates to:
  /// **'Failed to archive episode'**
  String get failedToArchiveEpisode;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @archiveAction.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveAction;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @removeImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove image?'**
  String get removeImageTitle;

  /// No description provided for @removeImageMovieMessage.
  ///
  /// In en, this message translates to:
  /// **'This will clear the current poster from the movie.'**
  String get removeImageMovieMessage;

  /// No description provided for @removeImageEpisodeMessage.
  ///
  /// In en, this message translates to:
  /// **'This will clear the current image from the episode.'**
  String get removeImageEpisodeMessage;

  /// No description provided for @removeVideoTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove video?'**
  String get removeVideoTitle;

  /// No description provided for @removeVideoMessage.
  ///
  /// In en, this message translates to:
  /// **'This will clear the current video from the episode.'**
  String get removeVideoMessage;

  /// No description provided for @archiveMovieTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive movie?'**
  String get archiveMovieTitle;

  /// No description provided for @archiveMovieMessage.
  ///
  /// In en, this message translates to:
  /// **'This movie will be hidden from viewers. You can restore it later.'**
  String get archiveMovieMessage;

  /// No description provided for @archiveEpisodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Archive episode?'**
  String get archiveEpisodeTitle;

  /// No description provided for @archiveEpisodeMessage.
  ///
  /// In en, this message translates to:
  /// **'This episode will be hidden from viewers. You can restore it later.'**
  String get archiveEpisodeMessage;

  /// No description provided for @deleteMovieTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete movie?'**
  String get deleteMovieTitle;

  /// No description provided for @deleteEpisodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete episode?'**
  String get deleteEpisodeTitle;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteMessage;

  /// No description provided for @noImage.
  ///
  /// In en, this message translates to:
  /// **'No image'**
  String get noImage;

  /// No description provided for @noVideo.
  ///
  /// In en, this message translates to:
  /// **'No video'**
  String get noVideo;

  /// No description provided for @allMovies.
  ///
  /// In en, this message translates to:
  /// **'All Movies'**
  String get allMovies;

  /// No description provided for @allCategory.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategory;

  /// No description provided for @comingSoonTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoonTitle;

  /// No description provided for @comingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'This feature will be added soon.'**
  String get comingSoonMessage;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;
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
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
