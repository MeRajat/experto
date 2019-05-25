import "dart:async";

class SearchBloc {
  
  final StreamController searchController = StreamController.broadcast();

  Stream get value => searchController.stream;

  void updateResult(result) {
    searchController.sink.add(result);
  }

  void dispose() {
    searchController.close();
  }
 }

final searchBloc = SearchBloc();

final expertSearchBloc = SearchBloc();
