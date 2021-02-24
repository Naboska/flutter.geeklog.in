class Chat {
  String date;
  String userName;
  String message;

  Chat({this.date, this.userName, this.message});

  Chat.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    userName = json['userName'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['userName'] = this.userName;
    data['message'] = this.message;
    return data;
  }
}
