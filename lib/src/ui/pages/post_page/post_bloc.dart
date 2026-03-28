import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shortflix/core/utils/base_state.dart';
import 'package:shortflix/core/utils/print_debug.dart';
import 'package:shortflix/src/models/category_model/category_model.dart';
import 'package:shortflix/src/models/post_model/post_model.dart';
import 'package:shortflix/src/repository/category_repo/category_repo.dart';
import 'package:shortflix/src/repository/post_repo/post_repo.dart';
import 'package:shortflix/src/ui/pages/post_page/post_event.dart';
import 'package:shortflix/src/ui/pages/post_page/post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepo postRepo;
  final CategoryRepo categoryRepo;

  PostBloc({required this.postRepo, required this.categoryRepo}) : super(PostInitial()) {
    on<PickVideoEvent>((event, emit) async {
      await _pickVideo(emit);
    });

    on<PickThumbnailEvent>((event, emit) async {
      await _pickThumbnail(emit);
    });

    on<CreatePostEvent>((event, emit) async {
      await _createPost(emit, event);
    });

    on<FetchCategoriesEvent>((event, emit) async{
      await _fetchCategories(emit);
    },);

    on<SelectCategoryEvent>((event, emit) {
      _selectCategory(emit, event.categoryId);
    },);
  }

  // ── Data ────────────────────────────────────────

List<CategoryModel> categories = [];

  // ── Picked file paths ────────────────────────────────────────
  String? videoPath;
  String? thumbnailPath;
  String selectedCategoryId = "";

  // ─────────────────────────────────────────
  //  PICK VIDEO
  // ─────────────────────────────────────────
  Future<void> _pickVideo(Emitter<PostState> emit) async {
    try {
      emit(PickVideoState(state: BaseState.loading));

      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        videoPath = result.files.single.path!;
        emit(PickVideoState(state: BaseState.loaded));
      } else {
        // user cancelled — go back to initial without clearing existing path
        emit(PickVideoState(state: BaseState.initial));
      }
    } catch (e) {
      emit(PickVideoState(state: BaseState.error));
      printDebug('PostBloc _pickVideo error => $e');
    }
  }

  // ─────────────────────────────────────────
  //  PICK THUMBNAIL
  // ─────────────────────────────────────────
  Future<void> _pickThumbnail(Emitter<PostState> emit) async {
    try {
      emit(PickThumbnailState(state: BaseState.loading));

      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (picked != null) {
        thumbnailPath = picked.path;
        emit(PickThumbnailState(state: BaseState.loaded));
      } else {
        emit(PickThumbnailState(state: BaseState.initial));
      }
    } catch (e) {
      emit(PickThumbnailState(state: BaseState.error));
      printDebug('PostBloc _pickThumbnail error => $e');
    }
  }

  // ─────────────────────────────────────────
  //  CREATE POST
  // ─────────────────────────────────────────
  Future<void> _createPost(
    Emitter<PostState> emit,
    CreatePostEvent event,
  ) async {
    try {
      emit(CreatePostState(state: BaseState.loading));

      await postRepo.createPost(
        PostModel(
          season: event.season,
          episode: event.episode,
          titleUz: event.titleUz,
          titleRu: event.titleRu,
          titleEn: event.titleEn,
          descriptionUz: event.descriptionUz,
          descriptionRu: event.descriptionRu,
          descriptionEn: event.descriptionEn,
          releaseYear: event.releaseYear,
          categoryId: event.categoryId,
          videoPath: videoPath!,
          imagePath: thumbnailPath!,
        ),
      );

      emit(CreatePostState(state: BaseState.loaded));
    } catch (e) {
      emit(CreatePostState(state: BaseState.error));
      printDebug('PostBloc _createPost error => $e');
    }
  }
  
  Future<void> _fetchCategories(Emitter<PostState> emit) async {
    try {
      emit(FetchCategoriesState(state: BaseState.loading));
      categories = await categoryRepo.fetchCategories();
      emit(FetchCategoriesState(state: BaseState.loaded));
    } catch (e) {
      emit(FetchCategoriesState(state: BaseState.error));
    }
  }
  
  void _selectCategory(Emitter<PostState> emit, String categoryId) {
    selectedCategoryId = categoryId;
    emit(SelectCategoryState(state: BaseState.loaded));
  }


}