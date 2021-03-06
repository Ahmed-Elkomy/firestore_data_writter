import 'package:firebase_core/firebase_core.dart';
import 'package:firestoredatawritter/src/repository/API/firestore_writer.dart';

import '../models/category.dart';
import '../models/models.dart';
import '../models/question.dart';
import 'API/api_interface.dart';
import 'API/mock_api.dart';
import 'API/trivia_api.dart';

class Repository {
  Repository() {
    print('REPOSITORY INIT');
  }

  final categories = List<Category>();
  final questions = List<Question>();
  QuestionsAPI api = MockAPI();

  bool needCategoriesLoading = true;

  void changeApi(ApiType type) {
    if (type == ApiType.mock) {
      api = MockAPI();
    } else {
      api = TriviaAPI();
    }
  }

  Future<bool> loadCategories() async {
    await Firebase.initializeApp();
    print('Need categories loading: $needCategoriesLoading');
    if (needCategoriesLoading) {
      categories
        ..clear()
        ..addAll(await FirestoreService.getCategories());

      needCategoriesLoading = false;
    }

    return true;
  }

  Future<List<Question>> loadQuestions(
      {int numQuestions,
      Category category,
      QuestionDifficulty difficulty,
      QuestionType type}) async {
    questions
      ..clear()
      ..addAll(await api.getQuestions(
          number: numQuestions,
          category: category,
          difficulty: difficulty,
          type: type))
      ..shuffle();

    print("AEK Question lenth: ${questions.length}");

    return questions;
  }
}
