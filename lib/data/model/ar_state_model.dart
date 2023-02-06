class ArState{
  bool? boot;
  bool? awake;
  bool? sleep;

  ArState({this.boot=false, this.awake=false, this.sleep=false});

  ArState.fromJson(Map<String, dynamic> json){
    if(json.isEmpty) return;

    boot=json['boot'];
    awake=json['awake'];
    sleep=json['sleep'];


  }
}