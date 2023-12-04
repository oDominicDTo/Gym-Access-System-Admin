import 'package:objectbox/objectbox.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

@Entity()
class Administrator {
  int id;

  @Unique()
  String username;
  String password;
  String nfcTagID;

  Administrator({this.id = 0, required this.username, required this.password, required this.nfcTagID});
}

@Entity()
class Member {
  int id;

  String firstName;
  String lastName;
  String contactNumber;
  String email;
  String nfcTagID;

  @Property(type: PropertyType.date)
  DateTime dateOfBirth;

  @Property(type: PropertyType.date)
  DateTime dateCreated;

  String address;

  final membershipType = ToOne<MembershipType>();

  Member({
    this.id = 0,
    required this.firstName,
    required this.lastName,
    required this.contactNumber,
    required this.email,
    required this.dateOfBirth,
    required this.address,
    required this.nfcTagID,
    DateTime? dateCreated})
      : dateCreated = dateCreated ?? DateTime.now();

  String get dateCreatedFormat => DateFormat('dd.MM.yy HH:mm:ss').format(dateCreated);

  String get dateOfBirthFormat => DateFormat('dd.MM.yy').format(dateOfBirth);
}

@Entity()
class Attendance {
  int id;

  final member = ToOne<Member>();

  @Property(type: PropertyType.date)
  DateTime checkInTime;

  @Property(type: PropertyType.date)
  DateTime checkOutTime;

  Attendance({
    this.id = 0,
    required this.checkInTime,
    required this.checkOutTime,
  });
}

@Entity()
class MembershipType {
  int id;

  String typeName;
  double fee;
  double discount;
  bool isLifetime;

  MembershipType({
    this.id = 0,
    required this.typeName,
    required this.fee,
    required this.discount,
    required this.isLifetime,
  });
}
