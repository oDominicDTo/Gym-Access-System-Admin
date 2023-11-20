import 'package:intl/intl.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Member {
  int id;

  String firstName;

  String lastName;

  String contactNumber;

  final membershipType = ToOne<MemberType>();

  @Property(type: PropertyType.date)
  DateTime dateCreated;

  String nfcTagID;


  Member({required this.id, required this.firstName, required this.lastName, required this.contactNumber,  required this.nfcTagID,
    DateTime? dateCreated}): dateCreated = dateCreated ?? DateTime.now();

  String get dateCreatedFormat =>
      DateFormat('dd.MM.yy HH:mm:ss').format(dateCreated);
}

@Entity()
class Attendance {
  int id;
  final name = ToOne<Member>();

  @Property(type: PropertyType.date)
  DateTime date;

  @Property(type: PropertyType.date)
  DateTime checkInTime;

  @Property(type: PropertyType.date)
  DateTime checkOutTime;


  Attendance({required this.id, DateTime? date, DateTime? checkInTime})
      : checkInTime = checkInTime ?? DateTime.now(),
        date = date ?? DateTime.now();


  String get dateCreatedFormat =>
      DateFormat('dd.MM.yy').format(date);

  String get timeInFormat =>
      DateFormat('HH:mm:ss').format(checkInTime);

  String get timeOutFormat =>
      DateFormat('HH:mm:ss').format(checkOutTime!);

  bool isFinished() {
    return checkOutTime != null;
  }

  void toggleFinished() {
    if (isFinished()) {
      checkOutTime = null;
    } else {
      checkOutTime = DateTime.now();
    }
  }
}

@Entity() // Signals ObjectBox to create a Box for this class.
class MemberType {
  // Every @Entity requires an int property named 'id'
  // or an int property with any name annotated with @Id().
  @Id()
  int id;
  String name;

  MemberType(this.name, {this.id = 0});
}