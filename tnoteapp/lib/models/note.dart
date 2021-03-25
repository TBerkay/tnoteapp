class Note {
  int id;
  String title;
  String description;
  String date;

  Note(this.title,this.description,this.date);

  Note.withId(this.id,this.title,this.description,this.date);

  Note.fromObject(dynamic o){
    this.id = o["id"];
    this.title = o["title"];
    this.description = o["description"];
    this.date = o["date"];
  }

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map["title"] = this.title;
    map["description"] = this.description;
    map["date"] = this.date;
    if(this.id != null){
      map["id"] = this.id;
    }
    return map;
  }

}