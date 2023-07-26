class Task {
  static const String collectionName = 'taskcollection';
  String? id;
  String? title;
  String? desc;
  DateTime? date;
  bool? isDone;

  Task({this.id, this.title, this.desc, this.date, this.isDone=false});

  Task.fromFireStore(Map<String,dynamic>?data):this(
    id: data?['id'],
    title: data?['title'],
    desc: data?['desc'],
    date: DateTime.fromMillisecondsSinceEpoch(data?['date']),
    isDone: data?['isdone'],
  );
  Map<String,dynamic> toFireStore(){
    return {
      'id':id,
      'title':title,
      'desc':desc,
      'date':date!.millisecondsSinceEpoch,
      'isdone':isDone,
    };
  }
}
