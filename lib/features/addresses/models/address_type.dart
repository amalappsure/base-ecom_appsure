// ignore_for_file: public_member_api_docs, sort_constructors_first
class AddressType {
  AddressType({
    required this.id,
    required this.name,
  });
  final int id;
  final String name;

  @override
  String toString() => name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  bool operator ==(covariant AddressType other) {
    return other.id == id;
  }
}
