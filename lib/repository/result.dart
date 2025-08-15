sealed class Result<T> {
  const Result();
}

/// Успешный результат
class Success<T> extends Result<T> {
  final T data;
  final bool isNetworkData = true;
  const Success(this.data, [isNetworkData]);
}

/// Ошибка
class Failure<T> extends Result<T> {
  final String message;
  const Failure(this.message);
}