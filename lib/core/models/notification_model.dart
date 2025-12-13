class NotificationModel {
  final String title;
  final String description;
 
  final String time;

  NotificationModel({
    required this.title,
    required this.description,
  
    required this.time,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        
        'time': time,
      };

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        title: json['title'],
        description: json['description'],
       
        time: json['time'],
      );
}
