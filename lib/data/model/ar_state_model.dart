class ArState{
  bool? boot;
  bool? awake;
  bool? sleep;

  ArState({this.boot=false, this.awake=true, this.sleep=false});

  ArState.fromJson(Map<String, dynamic> json){
    if(json.isEmpty) return;

    boot=json['boot'];
    awake=json['awake'];
    sleep=json['sleep'];
  }

  ArState negateValue(){
    return ArState(
      awake: !awake!,
      sleep: !sleep!,
      boot: !boot!
    );
  }
}