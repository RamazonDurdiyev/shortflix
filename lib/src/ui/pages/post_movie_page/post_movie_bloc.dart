import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/category_model/category_model.dart';
import 'package:shortflix/src/repository/category_repo/category_repo.dart';
import 'package:shortflix/src/repository/movie_repo/movie_repo.dart';
import 'package:shortflix/src/ui/pages/post_movie_page/post_movie_event.dart';
import 'package:shortflix/src/ui/pages/post_movie_page/post_movie_state.dart';

class PostMovieBloc extends Bloc<PostMovieEvent, PostMovieState> {
  final MovieRepo movieRepo;
  final CategoryRepo categoryRepo;

  PostMovieBloc({required this.movieRepo, required this.categoryRepo})
      : super(PostMovieInitial()) {
    on<PickImageEvent>((event, emit) async {
      await _pickImage(emit);
    });

    on<FetchCategoriesEvent>((event, emit) async {
      await _fetchCategories(emit);
    });

    on<SelectCategoryEvent>((event, emit) {
      selectedCategoryId = event.categoryId;
      emit(SelectCategoryState(categoryId: event.categoryId));
    });

    on<SelectAgeLimitEvent>((event, emit) {
      selectedAgeLimit = event.ageLimit;
      emit(SelectAgeLimitState(ageLimit: event.ageLimit));
    });

    on<CreateMovieEvent>((event, emit) async {
      await _createMovie(emit, event);
    });
  }

  String? imagePath;
  String selectedCategoryId = '';
  String selectedAgeLimit = '';
  List<CategoryModel> categories = [];

  // ─────────────────────────────────────────
  //  PICK IMAGE
  // ─────────────────────────────────────────
  Future<void> _pickImage(Emitter<PostMovieState> emit) async {
    try {
      emit(PickImageState(state: BaseState.loading));
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (picked != null) {
        imagePath = picked.path;
        emit(PickImageState(state: BaseState.loaded));
      } else {
        emit(PickImageState(state: BaseState.initial));
      }
    } catch (e) {
      emit(PickImageState(state: BaseState.error));
      printDebug('PostMovieBloc _pickImage error => $e');
    }
  }

  // ─────────────────────────────────────────
  //  FETCH CATEGORIES
  // ─────────────────────────────────────────
  Future<void> _fetchCategories(Emitter<PostMovieState> emit) async {
    try {
      emit(FetchCategoriesState(state: BaseState.loading));
      categories = await categoryRepo.fetchCategories();
      emit(FetchCategoriesState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchCategoriesState(state: BaseState.error));
      printDebug('PostMovieBloc _fetchCategories error => $e');
    }
  }

  // ─────────────────────────────────────────
  //  CREATE MOVIE
  // ─────────────────────────────────────────
  Future<void> _createMovie(
    Emitter<PostMovieState> emit,
    CreateMovieEvent event,
  ) async {
    try {
      emit(CreateMovieState(state: BaseState.loading));

      await movieRepo.postMovie(
        titleUz: event.titleUz,
        titleRu: event.titleRu,
        titleEn: event.titleEn,
        descriptionUz: event.descriptionUz,
        descriptionRu: event.descriptionRu,
        descriptionEn: event.descriptionEn,
        ageLimit: selectedAgeLimit,
        releaseYear: event.releaseYear,
        categoryId: selectedCategoryId,
        imageUrl: imagePath ?? '',
      );

      emit(CreateMovieState(state: BaseState.loaded));
    } catch (e) {
      emit(CreateMovieState(state: BaseState.error));
      printDebug('PostMovieBloc _createMovie error => $e');
    }
  }
}