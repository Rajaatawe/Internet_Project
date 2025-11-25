class Service {
  Service({
    required this.id,
    required this.arName,
    required this.enName,
    required this.arDescription,
    required this.enDescription,
    required this.iconImage,
    required this.descriptionImage,
  });

  late final int id;
  late final String arName;
  late final String enName;
  late final String arDescription;
  late final String enDescription;
  late final String iconImage;
  late final String descriptionImage;
  late final double price;

  Service.fromJson(Map<String, dynamic> json){
    id = json['id'];
    arName = json['ar_name'];
    enName = json['en_name'];
    arDescription = json['ar_description'];
    enDescription = json['en_description'];
    iconImage = json['iconImage'];
    descriptionImage = json['descriptionImage'];
    price=json['price']+0.0;

  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['ar_name'] = arName;
    _data['en_name'] = enName;
    _data['ar_description'] = arDescription;
    _data['en_description'] = enDescription;
    _data['iconImage'] = iconImage;
    _data['descriptionImage'] = descriptionImage;
    _data['price']=price;
    return _data;
  }
}