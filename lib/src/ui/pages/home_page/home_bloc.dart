import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/banner_model/banner_model.dart';
import 'package:shortflix/src/models/category_model/category_model.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/models/user_model/user_model.dart';
import 'package:shortflix/src/repository/category_repo/category_repo.dart';
import 'package:shortflix/src/repository/movie_repo/movie_repo.dart';
import 'package:shortflix/src/repository/notifications_repo/notifications_repo.dart';
import 'package:shortflix/src/repository/user_repo/user_repo.dart';
import 'package:shortflix/src/ui/pages/home_page/home_event.dart';
import 'package:shortflix/src/ui/pages/home_page/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{

  final CategoryRepo categoryRepo;
  final MovieRepo movieRepo;
  final UserRepo userRepo;
  final NotificationsRepo notificationsRepo;

  HomeBloc({
    required this.categoryRepo,
    required this.movieRepo,
    required this.userRepo,
    required this.notificationsRepo,
  }) : super(Initial()){
    on<FetchCategoriesEvent>((event, emit) async{
      await _fetchCategories(emit);
    },);
    on<FetchMoviesEvent>((event, emit) async{
      await _fetchMovies(emit);
    },);
    on<FetchBannersEvent>((event, emit) async{
      await _fetchBanners(emit);
    },);
    on<FetchUserEvent>((event, emit) async {
      await _fetchUser(emit);
    });
    on<FetchUnreadCountEvent>((event, emit) async {
      await _fetchUnreadCount(emit);
    });
    on<SearchMoviesEvent>((event, emit) async {
      await _searchMovies(emit, event.query);
    });
    on<ClearSearchEvent>((event, emit) {
      searchResults = [];
      isSearching = false;
      emit(ClearSearchState());
    });
    on<ChangeNavBarIndexEvent>((event, emit) {
       _changeNavBarIndex(emit, event.navBarIndex);
    },);
  }


  List<CategoryModel> categories = [];
  List<MovieModel> movies = [];
  List<BannerModel> banners = [];
  List<MovieModel> searchResults = [];
  UserModel? user;
  int unreadCount = 0;
  bool isSearching = false;
  int currentNavBarIndex = 0;
  
  Future<void> _fetchCategories(Emitter<HomeState> emit) async {
    try {
      emit(FetchCategoriesState(state: BaseState.loading));
      categories = await categoryRepo.fetchCategories();
      emit(FetchCategoriesState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchCategoriesState(state: BaseState.error));
      printDebug("HomeBloc _fetchCategories error => $e");
    }
  }
  
  Future<void> _fetchMovies(Emitter<HomeState> emit) async {
    try {
      emit(FetchMoviesState(state: BaseState.loading));
      movies = await movieRepo.fetchMovies();
      emit(FetchMoviesState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchMoviesState(state: BaseState.error));
      printDebug("HomeBloc _fetchMovies error => $e");
    }
  }
  
  Future<void> _fetchUser(Emitter<HomeState> emit) async {
    try {
      emit(FetchUserState(state: BaseState.loading));
      user = await userRepo.fetchCurrentUser();
      emit(FetchUserState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchUserState(state: BaseState.error));
      printDebug("HomeBloc _fetchUser error => $e");
    }
  }

  Future<void> _fetchUnreadCount(Emitter<HomeState> emit) async {
    try {
      emit(FetchUnreadCountState(state: BaseState.loading));
      unreadCount = await notificationsRepo.unreadCount();
      emit(FetchUnreadCountState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchUnreadCountState(state: BaseState.error));
      printDebug("HomeBloc _fetchUnreadCount error => $e");
    }
  }

  Future<void> _fetchBanners(Emitter<HomeState> emit) async {
    try {
      emit(FetchBannersState(state: BaseState.loading));
      banners = await movieRepo.fetchMovieBanners();
      emit(FetchBannersState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchBannersState(state: BaseState.error));
      printDebug("HomeBloc _fetchBanners error => $e");
    }
  }
  
 Future<void> _searchMovies(Emitter<HomeState> emit, String query) async {
    try {
      isSearching = true;
      emit(SearchMoviesState(state: BaseState.loading));
      searchResults = await movieRepo.searchMovies(query);
      emit(SearchMoviesState(state: BaseState.loaded));
    } catch (e) {
      emit(SearchMoviesState(state: BaseState.error));
      printDebug("HomeBloc _searchMovies error => $e");
    }
  }

 void _changeNavBarIndex(Emitter<HomeState> emit, int index) {
  currentNavBarIndex = index;
  emit(ChangeNavBarIndexState(state: BaseState.loaded));
}

}