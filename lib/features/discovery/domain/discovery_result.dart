enum DiscoveryFailureKind { notConfigured, timeout, serverError }

sealed class DiscoveryResult<T> {
  const DiscoveryResult();
}

final class DiscoverySuccess<T> extends DiscoveryResult<T> {
  const DiscoverySuccess(this.value);

  final T value;
}

final class DiscoveryFailure<T> extends DiscoveryResult<T> {
  const DiscoveryFailure({required this.kind, required this.message});

  final DiscoveryFailureKind kind;
  final String message;
}
