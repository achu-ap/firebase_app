class TodoModel {
  final String title;
  final String des;
  final String time;
  final String Userid;
  TodoModel({
    required this.title,
    required this.des,
    required this.time,
    required this.Userid,
  });
  toJSON() {
    return {
      "title": title,
      "des": des,
      "userId": Userid,
      "time": time.toString(),
    };
  }
}
