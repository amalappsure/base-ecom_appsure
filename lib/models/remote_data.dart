class RemoteData<T> {
  T? data;
  Exception? error;

  RemoteData({
    this.data,
    this.error,
  });

  RemoteData.loading();
  RemoteData.data({
    required this.data,
  });
  RemoteData.error({
    required this.error,
  });

  RemoteData<T> copyWith({
    T? data,
    Exception? error,
  }) {
    return RemoteData<T>(
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  RemoteDataState get dataState {
    if (data != null) return RemoteDataState.success;
    if (error != null) return RemoteDataState.error;
    return RemoteDataState.loading;
  }

  bool get isLoading => dataState == RemoteDataState.loading;

  bool get isSuccess => dataState == RemoteDataState.success && data != null;

  TResult when<TResult extends Object?>({
    required TResult Function() onLoading,
    required TResult Function(T data) onSuccess,
    required TResult Function(Exception error) onError,
  }) {
    switch (dataState) {
      case RemoteDataState.loading:
        return onLoading();
      case RemoteDataState.success:
        return onSuccess(data as T);
      case RemoteDataState.error:
        return onError(error!);
    }
  }

  void doWhen({
    Function()? onLoading,
    Function(T data)? onSuccess,
    Function(Exception error)? onError,
  }) {
    switch (dataState) {
      case RemoteDataState.loading:
        if (onLoading != null) {
          onLoading();
        }
      case RemoteDataState.success:
        if (onSuccess != null) {
          onSuccess(data as T);
        }
      case RemoteDataState.error:
        if (onError != null) {
          onError(error!);
        }
    }
  }

  @override
  String toString() =>
      'RemoteData<${data.runtimeType}>(data: $data, error: $error)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RemoteData<T> && other.data == data && other.error == error;
  }

  @override
  int get hashCode => data.hashCode ^ error.hashCode;
}

enum RemoteDataState { loading, success, error }
