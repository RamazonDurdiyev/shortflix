// ignore_for_file: constant_identifier_names

const String BASE_URL = "http://72.62.0.138:5001";
const int CONNECT_TIME_OUT = 30000;
const int SEND_TIME_OUT = 30000;
const int RECEIVE_TIME_OUT = 30000;

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
const GET_ALL_MOVIES_OF_USER = "/api/movies";
const GET_MOVIE_DETAILS = "/api/movies/";
const GET_BANNERS = "/api/movies/banner";
const CREATE_MOVIE = "/api/movies";
const CREATE_EPISODE = "/api/episodes";
const LIKE_MOVIE = "/api/movies/like/";
const SAVE_MOVIE = "/api/movies/save/";
const GET_EPISODES = "/api/movies/episodes/";
const GET_EPISODE = "/api/episodes/filter";

// Local data

const USER_TOKEN = "auth";