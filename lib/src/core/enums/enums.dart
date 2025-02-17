// ignore: constant_identifier_names
enum UserType { USER, ENTREPRENEUR }

extension UserTypeExt on String? {
  UserType? get getType {
    if (this == UserType.USER.name) return UserType.USER;
    if (this == UserType.ENTREPRENEUR.name) return UserType.ENTREPRENEUR;
    return null;
  }
}
