import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/category_model/category_model.dart';
import 'package:shortflix/src/repository/category_repo/category_repo.dart';
import 'package:shortflix/src/repository/movie_repo/movie_repo.dart';
import 'package:shortflix/src/ui/pages/edit_movie_page/edit_movie_event.dart';
import 'package:shortflix/src/ui/pages/edit_movie_page/edit_movie_state.dart';

class EditMovieBloc extends Bloc<EditMovieEvent, EditMovieState> {
  final MovieRepo movieRepo;
  final CategoryRepo categoryRepo;
  final String movieId;
  final String? initialImageUrl;

  EditMovieBloc({
    required this.movieRepo,
    required this.categoryRepo,
    required this.movieId,
    required String initialCategoryId,
    required String initialAgeLimit,
    this.initialImageUrl,
  }) : super(EditMovieInitial()) {
    selectedCategoryId = initialCategoryId;
    selectedAgeLimit = initialAgeLimit;

    on<FetchCategoriesEvent>((event, emit) async => _fetchCategories(emit));
    on<PickImageEvent>((event, emit) async => _pickImage(emit));
    on<RemoveImageEvent>((event, emit) {
      imagePath = null;
      imageRemoved = true;
      emit(RemoveImageState());
    });
    on<SelectCategoryEvent>((event, emit) {
      selectedCategoryId = event.categoryId;
      emit(SelectCategoryState(categoryId: event.categoryId));
    });
    on<SelectAgeLimitEvent>((event, emit) {
      selectedAgeLimit = event.ageLimit;
      emit(SelectAgeLimitState(ageLimit: event.ageLimit));
    });
    on<UpdateMovieEvent>(_updateMovie);
    on<DeleteMovieEvent>((event, emit) async => _deleteMovie(emit));
    on<ArchiveMovieEvent>((event, emit) async => _archiveMovie(emit));
  }

  String? imagePath;
  bool imageRemoved = false;
  String selectedCategoryId = '';
  String selectedAgeLimit = '';
  List<CategoryModel> categories = [];

  String? get currentImageUrl =>
      imageRemoved ? null : (imagePath == null ? initialImageUrl : null);

  Future<void> _fetchCategories(Emitter<EditMovieState> emit) async {
    try {
      emit(FetchCategoriesState(state: BaseState.loading));
      categories = await categoryRepo.fetchCategories();
      emit(FetchCategoriesState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchCategoriesState(state: BaseState.error));
      printDebug('EditMovieBloc _fetchCategories error => $e');
    }
  }

  Future<void> _pickImage(Emitter<EditMovieState> emit) async {
    try {
      emit(PickImageState(state: BaseState.loading));
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (picked != null) {
        imagePath = picked.path;
        imageRemoved = false;
        emit(PickImageState(state: BaseState.loaded));
      } else {
        emit(PickImageState(state: BaseState.initial));
      }
    } catch (e) {
      emit(PickImageState(state: BaseState.error));
      printDebug('EditMovieBloc _pickImage error => $e');
    }
  }

  Future<void> _updateMovie(
    UpdateMovieEvent event,
    Emitter<EditMovieState> emit,
  ) async {
    try {
      emit(UpdateMovieState(state: BaseState.loading));

      String? imageUrl;
      if (imagePath != null) {
        imageUrl = await movieRepo.uploadImage(imagePath!);
      } else if (imageRemoved) {
        imageUrl = '';
      }

      await movieRepo.updateMovie(
        movieId: movieId,
        title: event.title,
        description: event.description,
        ageLimit: selectedAgeLimit,
        releaseYear: event.releaseYear,
        categoryId: selectedCategoryId,
        imageUrl: imageUrl,
      );

      emit(UpdateMovieState(state: BaseState.loaded));
    } catch (e) {
      emit(UpdateMovieState(state: BaseState.error));
      printDebug('EditMovieBloc _updateMovie error => $e');
    }
  }

  Future<void> _deleteMovie(Emitter<EditMovieState> emit) async {
    try {
      emit(DeleteMovieState(state: BaseState.loading));
      await movieRepo.deleteMovie(movieId);
      emit(DeleteMovieState(state: BaseState.loaded));
    } catch (e) {
      emit(DeleteMovieState(state: BaseState.error));
      printDebug('EditMovieBloc _deleteMovie error => $e');
    }
  }

  Future<void> _archiveMovie(Emitter<EditMovieState> emit) async {
    try {
      emit(ArchiveMovieState(state: BaseState.loading));
      await movieRepo.archiveMovie(movieId);
      emit(ArchiveMovieState(state: BaseState.loaded));
    } catch (e) {
      emit(ArchiveMovieState(state: BaseState.error));
      printDebug('EditMovieBloc _archiveMovie error => $e');
    }
  }
}
