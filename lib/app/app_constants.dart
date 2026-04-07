// ignore_for_file: constant_identifier_names

const String BASE_URL = "http://72.62.0.138:5001";
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

// Movies

const GET_ALL_MOVIES = "/api/movies";
const SEARCH_MOVIES = "/api/movies/search";
const GET_ALL_MOVIES_OF_USER = "/api/movies/my";
const GET_MOVIE_DETAILS = "/api/movies/";
const GET_BANNERS = "/api/movies/banner";
const CREATE_MOVIE = "/api/movies";
const SAVE_MOVIE = "/api/movies/save/";
const RATE_MOVIE = "/api/ratings";
const UPDATE_RATE_MOVIE = "/api/ratings/movies/";
const SAVED_MOVIES = "/api/users/me/saved";

// Episodes

const CREATE_EPISODE = "/api/episodes";
const LIKE_EPISODE = "/api/episodes/like/";
const SAVE_EPISODE = "/api/episodes/save/";
const GET_EPISODES = "/api/movies/episodes/";
const GET_EPISODE = "/api/episodes/filter";
const SAVED_EPISODES = "/api/users/me/saved-episodes";
const LIKED_EPISODES = "/api/users/me/liked-episodes";

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

// API Keys

const MEDIA_UPLOAD = "http://72.62.0.138:5001/api/upload/presigned-url";