class BookModel {
  String? id;
  String title;
  String author;
  bool available;

  BookModel({
    this.id,
    required this.title,
    required this.author,
    required this.available,
  });

  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "author": author,
    "available": available,
  };

  factory BookModel.fromMap(Map<String, dynamic> map) => BookModel(
    id: map['id'].toString(),
    title: map['title'].toString(),
    author: map['author'].toString(),
    // Verificação de Valor
    available: map['available'] == true ? true : false,
  );
}
