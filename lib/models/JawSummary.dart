import 'package:ey_hack/models/BackGroundImage.dart';
import 'package:ey_hack/models/Genres.dart';
import 'package:ey_hack/models/LogoImage.dart';
import 'package:ey_hack/models/cast.dart';

class JawSummary {
  final String title;
  final Cast cast;
  final Genres genres;
  final String description;
  final LogoImage logoimage;
  final BackGroundImage backGroundImage;

  JawSummary(
      {required this.title,
      required this.cast,
      required this.genres,
      required this.description,
      required this.logoimage,
      required this.backGroundImage});
}
