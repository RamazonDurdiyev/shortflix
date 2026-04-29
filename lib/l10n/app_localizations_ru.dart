// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get language => 'Язык';

  @override
  String get languageUzbek => 'Узбекский';

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get profile => 'Профиль';

  @override
  String get profileFallbackName => 'Пользователь';

  @override
  String get profileFallbackEmail => 'someone@email.com';

  @override
  String get premium => 'Премиум';

  @override
  String get statWatched => 'Просмотрено';

  @override
  String get statWatchlist => 'К просмотру';

  @override
  String get statLiked => 'Нравится';

  @override
  String get sectionAccount => 'Аккаунт';

  @override
  String get sectionSupport => 'Поддержка';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get privacyAndSecurity => 'Конфиденциальность и безопасность';

  @override
  String get helpCenter => 'Центр помощи';

  @override
  String get about => 'О приложении';

  @override
  String get logOut => 'Выйти';

  @override
  String get logoutFailed => 'Не удалось выйти. Попробуйте ещё раз.';

  @override
  String get logoutConfirmTitle => 'Выйти?';

  @override
  String get logoutConfirmMessage =>
      'Чтобы продолжить смотреть, нужно будет войти снова.';

  @override
  String get cancel => 'Отмена';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get privacyPolicyLoadFailed =>
      'Не удалось загрузить Политику конфиденциальности';

  @override
  String get dangerZone => 'Опасная зона';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get deleteAccountConfirmTitle => 'Удалить аккаунт?';

  @override
  String get deleteAccountConfirmMessage =>
      'Ваш аккаунт будет запланирован к удалению и окончательно удалён через 30 дней. В течение этих 30 дней вы можете восстановить его в любой момент, просто войдя снова.';

  @override
  String get deleteAccountFailed =>
      'Не удалось удалить аккаунт. Попробуйте ещё раз.';

  @override
  String get editProfileTitle => 'Редактировать профиль';

  @override
  String get fullName => 'Полное имя';

  @override
  String get fullNameHint => 'Иван Иванов';

  @override
  String get fullNameError => 'Введите полное имя';

  @override
  String get phone => 'Телефон';

  @override
  String get phoneHint => '+998901234567';

  @override
  String get phoneError => 'Введите корректный номер';

  @override
  String get dateOfBirth => 'Дата рождения';

  @override
  String get selectDateOfBirth => 'Выберите дату рождения';

  @override
  String get change => 'Изменить';

  @override
  String get saveChanges => 'Сохранить';

  @override
  String get uploadPhoto => 'Загрузить фото';

  @override
  String get changePhoto => 'Изменить фото';

  @override
  String get profileUpdated => 'Профиль обновлён';

  @override
  String get profileUpdateFailed => 'Не удалось обновить профиль';

  @override
  String get pickImageFailed => 'Не удалось выбрать изображение';

  @override
  String get myLibrary => 'Моя библиотека';

  @override
  String get myMovies => 'Мои фильмы';

  @override
  String get myMoviesSubtitle => 'Фильмы, которые вы создали';

  @override
  String get saved => 'Сохранённое';

  @override
  String get savedSubtitle => 'Сохранённые фильмы и эпизоды';

  @override
  String get likedEpisodes => 'Понравившиеся эпизоды';

  @override
  String get likedEpisodesSubtitle => 'Эпизоды, которые вам понравились';

  @override
  String get archived => 'Архив';

  @override
  String get archivedSubtitle => 'Фильмы и эпизоды в архиве';

  @override
  String get tabMovies => 'Фильмы';

  @override
  String get tabEpisodes => 'Эпизоды';

  @override
  String moviesBy(String name) {
    return 'Фильмы пользователя $name';
  }

  @override
  String notifLikedYourEpisode(String name) {
    return '$name оценил(а) ваш эпизод';
  }

  @override
  String notifCommentedOnYourEpisode(String name) {
    return '$name прокомментировал(а) ваш эпизод';
  }

  @override
  String notifInteractedWithYou(String name) {
    return '$name взаимодействовал(а) с вашим контентом';
  }

  @override
  String get noMoviesYet => 'Пока нет фильмов';

  @override
  String get noMoviesCreatedYet => 'Вы ещё не создали ни одного фильма';

  @override
  String get failedToLoadMovies => 'Не удалось загрузить фильмы';

  @override
  String get failedToLoadYourMovies => 'Не удалось загрузить ваши фильмы';

  @override
  String get failedToLoadLikedEpisodes =>
      'Не удалось загрузить понравившиеся эпизоды';

  @override
  String get noLikedEpisodesYet => 'Пока нет понравившихся эпизодов';

  @override
  String get failedToLoadSavedMovies =>
      'Не удалось загрузить сохранённые фильмы';

  @override
  String get noSavedMoviesYet => 'Пока нет сохранённых фильмов';

  @override
  String get failedToLoadSavedEpisodes =>
      'Не удалось загрузить сохранённые эпизоды';

  @override
  String get noSavedEpisodesYet => 'Пока нет сохранённых эпизодов';

  @override
  String get failedToLoadArchivedMovies =>
      'Не удалось загрузить архивные фильмы';

  @override
  String get noArchivedMovies => 'В архиве нет фильмов';

  @override
  String get failedToLoadArchivedEpisodes =>
      'Не удалось загрузить архивные эпизоды';

  @override
  String get noArchivedEpisodes => 'В архиве нет эпизодов';

  @override
  String get create => 'Создать';

  @override
  String get whatDoYouWantToPost => 'Что вы хотите опубликовать?';

  @override
  String get movie => 'Фильм';

  @override
  String get movieActionSubtitle => 'Добавить новый фильм с описанием';

  @override
  String get episode => 'Эпизод';

  @override
  String get episodeActionSubtitle => 'Загрузить эпизод к существующему фильму';

  @override
  String get postMovie => 'Опубликовать фильм';

  @override
  String get postEpisode => 'Опубликовать эпизод';

  @override
  String get fieldTitle => 'Название';

  @override
  String get fieldDescription => 'Описание';

  @override
  String get titleHintMovie => 'напр.: Тёмный рыцарь';

  @override
  String get descriptionHintMovie =>
      'напр.: Преступность в Готэме на пике. Брюс Уэйн становится тёмным мстителем, чтобы защитить город';

  @override
  String get titleHintEpisode => 'напр.: Новое начало';

  @override
  String get descriptionHintEpisode =>
      'напр.: Герой прибывает в новый город и встречает неожиданного врага';

  @override
  String get releaseYear => 'Год выпуска';

  @override
  String get selectCategory => 'Выберите категорию';

  @override
  String get selectCategoryTitle => 'Выберите категорию';

  @override
  String get selectAgeLimit => 'Выберите возрастное ограничение';

  @override
  String get selectAgeLimitTitle => 'Выберите возрастное ограничение';

  @override
  String get selectMovie => 'Выберите фильм';

  @override
  String get selectMovieTitle => 'Выберите фильм';

  @override
  String get noMoviesFoundCreateFirst => 'Фильмов нет. Сначала создайте фильм.';

  @override
  String get season => 'Сезон';

  @override
  String get episodeNumberLabel => 'Эпизод №';

  @override
  String get pickImage => 'Выбрать изображение';

  @override
  String get changeImage => 'Изменить изображение';

  @override
  String get pickVideo => 'Выбрать видео';

  @override
  String get changeVideo => 'Изменить видео';

  @override
  String uploadingPercent(String percent) {
    return 'Загрузка $percent%';
  }

  @override
  String get failedToLoadCategories => 'Не удалось загрузить категории';

  @override
  String get pickVideoFailed => 'Не удалось выбрать видео';

  @override
  String get moviePostedSuccessfully => 'Фильм успешно опубликован';

  @override
  String get episodePostedSuccessfully => 'Эпизод успешно опубликован';

  @override
  String get somethingWentWrong => 'Что-то пошло не так';

  @override
  String get shorts => 'Шортс';

  @override
  String get failedToLoadShorts => 'Не удалось загрузить шортс';

  @override
  String get noShortsAvailable => 'Шортс пока нет';

  @override
  String get share => 'Поделиться';

  @override
  String get more => 'Ещё';

  @override
  String get save => 'Сохранить';

  @override
  String get comments => 'Комментарии';

  @override
  String get noCommentsYet => 'Комментариев пока нет';

  @override
  String get beFirstToComment => 'Оставьте первый комментарий';

  @override
  String get addAComment => 'Добавить комментарий...';

  @override
  String get user => 'Пользователь';

  @override
  String get justNow => 'только что';

  @override
  String minutesAgoShort(int count) {
    return '$count мин назад';
  }

  @override
  String hoursAgoShort(int count) {
    return '$count ч назад';
  }

  @override
  String daysAgoShort(int count) {
    return '$count дн назад';
  }

  @override
  String get navHome => 'Главная';

  @override
  String get navPost => 'Создать';

  @override
  String get navLibrary => 'Библиотека';

  @override
  String get hello => 'Привет, ';

  @override
  String get fallbackGreetingName => 'друг';

  @override
  String get whatAreYouWatchingToday => 'Что посмотрим сегодня?';

  @override
  String get searchMoviesHint => 'Поиск фильмов, сериалов, жанров…';

  @override
  String get featuredToday => 'Недавно добавленные';

  @override
  String get popularOnShortflix => 'Популярное в 916TV';

  @override
  String get browseByGenre => 'Просмотр по жанрам';

  @override
  String get noMoviesFound => 'Фильмы не найдены';

  @override
  String searchResultsCount(int count) {
    return 'Результаты ($count)';
  }

  @override
  String get seeAll => 'Все';

  @override
  String seasonEpisodeLabel(int season, int episode) {
    return 'Сезон $season  ·  Эпизод $episode';
  }

  @override
  String episodeN(int number) {
    return 'Эпизод $number';
  }

  @override
  String seasonShort(int number) {
    return 'С$number';
  }

  @override
  String get failedToLoadEpisodes => 'Не удалось загрузить эпизоды';

  @override
  String get noEpisodesForSeason => 'В этом сезоне нет эпизодов';

  @override
  String get edit => 'Изменить';

  @override
  String get yourRating => 'Ваша оценка';

  @override
  String get rateThisMovie => 'Оцените фильм';

  @override
  String get creatorLabel => 'Автор: ';

  @override
  String get emailLabel => 'Эл. почта';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get emailError => 'Введите корректный email';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get passwordError => 'Пароль должен содержать не менее 6 символов';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get welcomeBack => 'С возвращением';

  @override
  String get signInSubtitle => 'Войдите, чтобы продолжить просмотр';

  @override
  String get signIn => 'Войти';

  @override
  String get orDivider => 'ИЛИ';

  @override
  String get continueWithGoogle => 'Продолжить с Google';

  @override
  String get continueWithApple => 'Продолжить с Apple';

  @override
  String get dontHaveAccount => 'Нет аккаунта? ';

  @override
  String get signUp => 'Регистрация';

  @override
  String get incorrectEmailOrPassword => 'Неверный email или пароль';

  @override
  String get googleSignInFailed =>
      'Не удалось войти через Google. Попробуйте ещё раз.';

  @override
  String get appleSignInFailed =>
      'Не удалось войти через Apple. Попробуйте ещё раз.';

  @override
  String get createAccountHeading => 'Создать аккаунт';

  @override
  String get createAccountSubtitle => 'Присоединяйтесь к миллионам на 916TV';

  @override
  String get createAccountButton => 'Создать аккаунт';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт? ';

  @override
  String get signUpFailed =>
      'Не удалось зарегистрироваться. Попробуйте ещё раз.';

  @override
  String get fullNameHintSignUp => 'Иван Иванов';

  @override
  String get checkYourEmail => 'Проверьте почту';

  @override
  String get sentCodeTo => 'Мы отправили 6-значный код на ';

  @override
  String get yourEmailFallback => 'вашу почту';

  @override
  String get verify => 'Подтвердить';

  @override
  String get didntReceiveCode => 'Не получили код? ';

  @override
  String get resend => 'Отправить ещё раз';

  @override
  String get invalidCode => 'Неверный код. Попробуйте ещё раз.';

  @override
  String get codeResent => 'Код отправлен повторно!';

  @override
  String get appTagline => 'Смотри. Открывай. Наслаждайся.';

  @override
  String get noConnection => 'Нет соединения';

  @override
  String get checkInternetConnection =>
      'Проверьте подключение к интернету и попробуйте ещё раз.';

  @override
  String get retry => 'Повторить';

  @override
  String get editMovie => 'Редактировать фильм';

  @override
  String get editEpisode => 'Редактировать эпизод';

  @override
  String get updateMovie => 'Обновить фильм';

  @override
  String get updateEpisode => 'Обновить эпизод';

  @override
  String get archiveMovie => 'Архивировать фильм';

  @override
  String get archiveEpisode => 'Архивировать эпизод';

  @override
  String get deleteMovie => 'Удалить фильм';

  @override
  String get deleteEpisode => 'Удалить эпизод';

  @override
  String get movieUpdated => 'Фильм обновлён';

  @override
  String get failedToUpdateMovie => 'Не удалось обновить фильм';

  @override
  String get episodeUpdated => 'Эпизод обновлён';

  @override
  String get failedToUpdateEpisode => 'Не удалось обновить эпизод';

  @override
  String get movieDeleted => 'Фильм удалён';

  @override
  String get failedToDeleteMovie => 'Не удалось удалить фильм';

  @override
  String get episodeDeleted => 'Эпизод удалён';

  @override
  String get failedToDeleteEpisode => 'Не удалось удалить эпизод';

  @override
  String get movieArchived => 'Фильм архивирован';

  @override
  String get failedToArchiveMovie => 'Не удалось архивировать фильм';

  @override
  String get episodeArchived => 'Эпизод архивирован';

  @override
  String get failedToArchiveEpisode => 'Не удалось архивировать эпизод';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get remove => 'Удалить';

  @override
  String get archiveAction => 'Архивировать';

  @override
  String get delete => 'Удалить';

  @override
  String get removeImageTitle => 'Удалить изображение?';

  @override
  String get removeImageMovieMessage => 'Текущий постер фильма будет удалён.';

  @override
  String get removeImageEpisodeMessage =>
      'Текущее изображение эпизода будет удалено.';

  @override
  String get removeVideoTitle => 'Удалить видео?';

  @override
  String get removeVideoMessage => 'Текущее видео эпизода будет удалено.';

  @override
  String get archiveMovieTitle => 'Архивировать фильм?';

  @override
  String get archiveMovieMessage =>
      'Фильм будет скрыт от зрителей. Вы сможете восстановить его позже.';

  @override
  String get archiveEpisodeTitle => 'Архивировать эпизод?';

  @override
  String get archiveEpisodeMessage =>
      'Эпизод будет скрыт от зрителей. Вы сможете восстановить его позже.';

  @override
  String get deleteMovieTitle => 'Удалить фильм?';

  @override
  String get deleteEpisodeTitle => 'Удалить эпизод?';

  @override
  String get deleteMessage => 'Это действие нельзя отменить.';

  @override
  String get noImage => 'Нет изображения';

  @override
  String get noVideo => 'Нет видео';

  @override
  String get allMovies => 'Все фильмы';

  @override
  String get allCategory => 'Все';
}
