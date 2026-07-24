class Failure {
  final String message;
  const Failure(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Failure && message == other.message;

  @override
  int get hashCode => message.hashCode;
}
