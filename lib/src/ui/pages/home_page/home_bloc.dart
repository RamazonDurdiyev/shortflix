import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/banner_model/banner_model.dart';
import 'package:shortflix/src/models/category_model/category_model.dart';
import 'package:shortflix/src/models/movie_model/movie_model.dart';
import 'package:shortflix/src/repository/category_repo/category_repo.dart';
import 'package:shortflix/src/repository/movie_repo/movie_repo.dart';
import 'package:shortflix/src/ui/pages/home_page/home_event.dart';
import 'package:shortflix/src/ui/pages/home_page/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{

  final CategoryRepo categoryRepo;
  final MovieRepo movieRepo;

  HomeBloc({required this.categoryRepo, required this.movieRepo}) : super(Initial()){
    on<FetchCategoriesEvent>((event, emit) async{
      await _fetchCategories(emit);
    },);
    on<FetchMoviesEvent>((event, emit) async{
      await _fetchMovies(emit);
    },);
    on<FetchBannersEvent>((event, emit) async{
      await _fetchBanners(emit);
    },);
  }

 
  List<CategoryModel> categories = [];
  List<MovieModel> movies = [];
  List<BannerModel> banners = [];
  
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

  
}