class Movie {
  final int id;
  final String title;
  final String? posterPath;
  double rating;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    this.rating = 0.0,
  });

  // Converte JSON da API TMDB em Objeto
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? 'Sem Título',
      posterPath: json['poster_path'],
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Converte do SQLite (Mapa) em Objeto
  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      posterPath: map['posterPath'],
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Converte do Objeto para SQLite (Mapa)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'rating': rating,
    };
  }

  // Getter para retornar a URL completa da Imagem
  String get fullImageUrl {
    if (posterPath == null || posterPath!.isEmpty) {
      return 'https://via.placeholder.com/500x750?text=Sem+Imagem';
    }
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }
}