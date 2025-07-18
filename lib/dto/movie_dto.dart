class MovieDTO {
  final String id;
  final String title;
  final String year;
  final String rated;
  final String released;
  final String runtime;
  final String genre;
  final String director;
  final String writer;
  final String actors;
  final String plot;
  final String language;
  final String country;
  final String awards;
  final String poster;
  final String metascore;
  final String imdbRating;
  final String imdbVotes;
  final String imdbID;
  final String type;
  final bool response;
  final List<String> images;
  final bool comingSoon;
  bool isFavorite;

  MovieDTO({required this.id, required this.title, required this.year, required this.rated, required this.released, required this.runtime, required this.genre, required this.director, required this.writer, required this.actors, required this.plot, required this.language, required this.country, required this.awards, required this.poster, required this.metascore, required this.imdbRating, required this.imdbVotes, required this.imdbID, required this.type, required this.response, required this.images, required this.comingSoon, this.isFavorite = false});

  factory MovieDTO.fromJson(Map<String, dynamic> json) {
    return MovieDTO(
      id: json['id'] as String,
      title: json['Title'] as String,
      year: json['Year'] as String,
      rated: json['Rated'] as String,
      released: json['Released'] as String,
      runtime: json['Runtime'] as String,
      genre: json['Genre'] as String,
      director: json['Director'] as String,
      writer: json['Writer'] as String,
      actors: json['Actors'] as String,
      plot: json['Plot'] as String,
      language: json['Language'] as String,
      country: json['Country'] as String,
      awards: json['Awards'] as String,
      poster: json['Poster'] as String,
      metascore: json['Metascore'] as String,
      imdbRating: json['imdbRating'] as String,
      imdbVotes: json['imdbVotes'] as String,
      imdbID: json['imdbID'] as String,
      type: json['Type'] as String,
      response: (json['Response'] as String).toLowerCase() == 'true',
      images: (json['Images'] as List<dynamic>).map((e) => e as String).toList(),
      comingSoon: json['ComingSoon'] as bool,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'Title': title, 'Year': year, 'Rated': rated, 'Released': released, 'Runtime': runtime, 'Genre': genre, 'Director': director, 'Writer': writer, 'Actors': actors, 'Plot': plot, 'Language': language, 'Country': country, 'Awards': awards, 'Poster': poster, 'Metascore': metascore, 'imdbRating': imdbRating, 'imdbVotes': imdbVotes, 'imdbID': imdbID, 'Type': type, 'Response': response ? 'True' : 'False', 'Images': images, 'ComingSoon': comingSoon, 'isFavorite': isFavorite};
  }
}
