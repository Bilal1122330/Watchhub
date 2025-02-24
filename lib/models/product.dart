class Product{
  late String code;
  late String name;
  late String desc;
  late String category;
  late double price;
  late String imageBase64;
  late String status; // available, out of stock, top selling, vendor recommended

  Product({
    required this.code,
    required this.name,
    required this.desc,
    required this.category,
    required this.price,
    required this.imageBase64,
    required this.status
  });

  Product.fromJson(Map<dynamic,dynamic> json)
      : code = json['code'] as String,
        name = json['name'] as String,
        desc = json['desc'] as String,
        category = json['category'] as String,
        price = json['price'] as double,
        imageBase64 = json ['imageBase64'] as String,
        status = json['status'] as String;

  Map<dynamic, dynamic> toMap() => <String,dynamic>{
    'code': code,
    'name':name,
    'desc':desc,
    'category':category,
    'price': price,
    'imageBase64':imageBase64,
    'status':status
  };

  Map<String, dynamic> toJson() => <String,dynamic>{
    'code': code,
    'name':name,
    'desc':desc,
    'category':category,
    'price': price,
    'imageBase64':imageBase64,
    'status':status
  };

}