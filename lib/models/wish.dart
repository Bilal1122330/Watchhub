class Wish{
  final String wishName;
  final String quantity;

  Wish({required this.wishName, required this.quantity});

  Wish.formJson(Map<dynamic,dynamic> json):
      wishName= json['wishName'] as String,
      quantity = json['quantity'] as String;

  Map<String,dynamic> toJson() =><String,dynamic>{
    'wishName':wishName,
    'quantity':quantity
  };


}