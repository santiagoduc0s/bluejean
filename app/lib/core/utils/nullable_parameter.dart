/// A class that represents a parameter with a value.
class NullableParameter<T> {
  /// Creates a [NullableParameter] with the given [value].
  NullableParameter(this.value);

  /// The value of the parameter.
  final T value;

  bool get isNull => value == null;
  bool get isNotNull => value != null;
}
