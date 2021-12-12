abstract class Result<T> {}

class Success<T> extends Result<T> {
  T data;
  Success({required this.data});
}

class Error<T> extends Result<T> {
  int statusCode;
  String message;
  Error({this.statusCode = 400, this.message = 'Unknown Error occurred'});
}
