// ignore_for_file: constant_identifier_names

const String BASE_URL = "https://shortflix.yaxshihayot.uz";
const int CONNECT_TIME_OUT = 30000;
const int SEND_TIME_OUT = 30000;
const int RECEIVE_TIME_OUT = 30000;

// User

const GET_USER = "/api/users/me";

// Categories

const CATEGORIES = "/api/categories";

// Auth
const SIGN_IN = "/api/auth/login";
const SIGN_UP = "/api/auth/register";
const VERIFY_CODE = "/api/auth/verify-otp";
const REFRESH = "/api/auth/refresh";
const SEND_CODE = "/api/auth/login";
const GOOGLE_AUTH = "/api/auth/google";


// OAuth client id
const GOOGLE_ANDROID_CLIENT_ID =
    "702398577621-dc0scstp50fdjihvp72bpusu1u5mmpl1.apps.googleusercontent.com";

const GOOGLE_IOS_CLIENT_ID =
    "702398577621-hug0kc079la1eropvk06bh24cr9qo32a.apps.googleusercontent.com";

const GOOGLE_WEB_CLIENT_ID = "702398577621-8cdiihlmbq1bsaco6u9p5gdr71eulkja.apps.googleusercontent.com";

// Movies

const GET_ALL_MOVIES = "/api/movies";
const SEARCH_MOVIES = "/api/movies/search";
String moviesByUser(String userId) => "/api/movies/user/$userId";
const GET_MOVIE_DETAILS = "/api/movies/";
const GET_BANNERS = "/api/movies/banner";
const CREATE_MOVIE = "/api/movies";
const UPDATE_MOVIE = "/api/movies/";
const DELETE_MOVIE = "/api/movies/";
const ARCHIVE_MOVIE = "/api/movies/archive/";
const SAVE_MOVIE = "/api/movies/save/";
const RATE_MOVIE = "/api/ratings";
const UPDATE_RATE_MOVIE = "/api/ratings/movies/";
const SAVED_MOVIES = "/api/users/me/saved";
const ARCHIVED_MOVIES = "/api/movies/my/archived";

// Episodes

const CREATE_EPISODE = "/api/episodes";
const UPDATE_EPISODE = "/api/episodes/";
const DELETE_EPISODE = "/api/episodes/";
const ARCHIVE_EPISODE = "/api/episodes/archive/";
const LIKE_EPISODE = "/api/episodes/like/";
const SAVE_EPISODE = "/api/episodes/save/";
const GET_EPISODES = "/api/movies/episodes/";
const GET_EPISODE = "/api/episodes/filter";
const SAVED_EPISODES = "/api/users/me/saved-episodes";
const LIKED_EPISODES = "/api/users/me/liked-episodes";
const ARCHIVED_EPISODES = "/api/users/me/archived-episodes";
const ARCHIVED_EPISODE_DETAILS = "/api/users/me/archived-episodes/";

// Comments

const ADD_COMMENT = "/api/comments";
 String episodeComments({
    required String filmId,
    required String episodeId,
  }) {
    return '/api/movies/$filmId/episodes/$episodeId/comments';
  }


// Shorts

const SHORTS = "/api/shorts";

// Local data

const USER_TOKEN = "auth";
const LANGUAGE = "language";

// API Keys

const MEDIA_UPLOAD = "http://72.62.0.138:5001/api/upload/presigned-url";