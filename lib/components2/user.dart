import 'package:app0/Screens/User/components/category_list.dart';
import 'package:app0/DB/database_provider.dart';

class User {
  final String oid, zipcode, emails, phone;
  final String displayName, type, status, image;

  User(
      {this.oid,
      this.zipcode,
      this.emails,
      this.phone,
      this.displayName,
      this.type,
      this.status,
      this.image});
}

User toUser(var current) {
  User user = User(
    oid: current[DatabaseProvider.COLUMN_OID].toString(),
    zipcode: current[DatabaseProvider.COLUMN_ZIPCODE].toString(),
    emails: current[DatabaseProvider.COLUMN_EMAILS].toString(),
    phone: current[DatabaseProvider.COLUMN_PHONE].toString(),
    displayName: current[DatabaseProvider.COLUMN_DISPLAY_NAME].toString(),
    type: current[DatabaseProvider.COLUMN_TYPE] == 'Parent'
        ? CategoryList.CATEGORY_PARENT
        : (current[DatabaseProvider.COLUMN_TYPE] == 'Family'
            ? CategoryList.CATEGORY_OTHER_USER
            : (current[DatabaseProvider.COLUMN_TYPE] == 'FamilyB'
                ? CategoryList.CATEGORY_FAMILY
                : CategoryList.CATEGORY_DESK)),
    status: current[DatabaseProvider.COLUMN_STATUS].toString(),
    image: current[DatabaseProvider.COLUMN_TYPE] == 'Parent'
        ? "assets/images/Parent.png"
        : (current[DatabaseProvider.COLUMN_TYPE] == 'Family'
            ? "assets/images/Family.png"
            : (current[DatabaseProvider.COLUMN_TYPE] == 'FamilyB'
                ? "assets/images/FamilyB.png"
                : "assets/images/Desk.png")),
  );
  return user;
}

Future<User> changeStatus(User old, String newStatus) async {
  User changed = User(
      oid: old.oid,
      zipcode: old.zipcode,
      emails: old.emails,
      phone: old.phone,
      displayName: old.displayName,
      type: old.type,
      status: newStatus,
      image: old.image);
  Map<String, String> user = {
    DatabaseProvider.COLUMN_OID: old.oid,
    DatabaseProvider.COLUMN_STATUS: newStatus
  };
  await DatabaseProvider.db.updateUser(user);
  return changed;
}
