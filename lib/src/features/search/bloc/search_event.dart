sealed class SearchEvent {
  const SearchEvent();
}

class SearchQueryChanged extends SearchEvent {
  const SearchQueryChanged(this.query);

  final String query;
}

class SearchSubmitted extends SearchEvent {
  const SearchSubmitted();
}

class SearchPageChanged extends SearchEvent {
  const SearchPageChanged(this.page);

  final int page;
}

class SearchRetried extends SearchEvent {
  const SearchRetried();
}
