class Option {
  String value = '';
  String detail = '';
  bool correct = false;

  Option({required this.correct, required this.value, required this.detail});
  Option.fromMap(Map data) {
    value = data['value'];
    detail = data['detail'] ?? '';
    correct = data['correct'];
  }
}

class Question {
  String? text;
  List<Option>? options = [];
  Question({required this.options, required this.text});

  Question.fromMap(Map data) {
    text = data['text'] ?? '';
    options = (data['options'] ?? []).map((v) => Option.fromMap(v)).toList();
  }
}

///// Database Collections

class Quiz {
  String id;
  String title;
  String description;
  String video;
  String topic;
  List<Question> questions;

  Quiz(
      {required this.title,
      required this.questions,
      required this.video,
      required this.description,
      required this.id,
      required this.topic});

  factory Quiz.fromMap(Map? data) {
    if (data == null) {
      throw Error();
    }

    return Quiz(
        id: data['id'] ?? '',
        title: data['title'] ?? '',
        topic: data['topic'] ?? '',
        description: data['description'] ?? '',
        video: data['video'] ?? '',
        questions:
            (data['questions'] ?? []).map((v) => Question.fromMap(v)).toList());
  }
}

class Topic {
  final String id;
  final String title;
  final String description;
  final String img;
  final List<Quiz> quizzes;

  Topic(
      {required this.id,
      required this.title,
      required this.description,
      required this.img,
      required this.quizzes});

  factory Topic.fromMap(Map data) {
    return Topic(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      img: data['img'] ?? 'default.png',
      quizzes: (data['quizzes'] ?? [])
          .map((v) => Quiz.fromMap(v))
          .toList(), //data['quizzes'],
    );
  }
}

class Report {
  String uid;
  int total;
  dynamic topics;

  Report({required this.uid, required this.topics, required this.total});

  factory Report.fromMap(Map data) {
    return Report(
      uid: data['uid'],
      total: data['total'] ?? 0,
      topics: data['topics'] ?? {},
    );
  }
}
