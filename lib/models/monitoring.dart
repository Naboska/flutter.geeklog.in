class Monitoring {
  bool success;
  String name;
  String status;
  int players;
  int playersMax;

  Monitoring(
      {this.success, this.name, this.status, this.players, this.playersMax});

  Monitoring.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    name = json['name'];
    status = json['status'];
    players = json['players'];
    playersMax = json['players_max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['name'] = this.name;
    data['status'] = this.status;
    data['players'] = this.players;
    data['players_max'] = this.playersMax;
    return data;
  }
}
