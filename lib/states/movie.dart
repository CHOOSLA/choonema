class Movie {
  final String movieNumber;
  final String movieTitle;
  final String movieDir;
  final String leadActor;

  Movie({this.movieNumber, this.movieTitle, this.movieDir, this.leadActor});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        movieNumber: json['movieNumber'],
        movieTitle: json['movieTitle'],
        movieDir: json['movieDir'],
        leadActor: json['leadActor']);
  }

  Map<String, dynamic> tojson() => {
        'movieNumber': movieNumber,
        'movieTitle': movieTitle,
        'movieDir': movieDir,
        'leadActor': leadActor
      };
}
