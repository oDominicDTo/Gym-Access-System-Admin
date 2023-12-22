import 'package:objectbox/objectbox.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

enum MembershipStatus { active, inactive, expired }

enum AdminRole { superAdmin, admin, staff }

@Entity()
class Administrator {
  int id;

  @Unique()
  String name;
  String username;
  String password;
  String nfcTagID;
  String type;

  Administrator(
      {this.id = 0,
      required this.name,
      required this.type,
      required this.username,
      required this.password,
      required this.nfcTagID});
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
  DateTime membershipStartDate;

  @Property(type: PropertyType.date)
  DateTime membershipEndDate;

  String address;

  final membershipType = ToOne<MembershipType>();

  String photoPath;

  Member(
      {this.id = 0,
      required this.firstName,
      required this.lastName,
      required this.contactNumber,
      required this.email,
      required this.dateOfBirth,
      required this.address,
      required this.nfcTagID,
      required this.membershipEndDate,
      required this.photoPath,
      DateTime? membershipStartDate,
      DateTime? dateCreated})
      : membershipStartDate = membershipStartDate ?? DateTime.now();

  String get dateOfBirthFormat => DateFormat('MMMM.dd.yy').format(dateOfBirth);

  String get membershipStartDateFormat =>
      DateFormat('MMMM.dd.yy').format(membershipStartDate);

  String get membershipEndDateFormat =>
      DateFormat('MMMM.dd.yy').format(membershipEndDate);

  int getRemainingMembershipDays() {
    final currentDate = DateTime.now();
    final remainingDays = membershipEndDate.difference(currentDate).inDays;
    return remainingDays > 0 ? remainingDays : 0;
  }

  String getFormattedMembershipEndDate() {
    return DateFormat('dd.MM.yyyy').format(membershipEndDate);
  }

  void extendMembership(int additionalDays) {
    membershipEndDate = membershipEndDate.add(Duration(days: additionalDays));
  }

  MembershipStatus getMembershipStatus() {
    final currentDate = DateTime.now();

    if (currentDate.isBefore(membershipEndDate)) {
      return MembershipStatus.active; // Membership is active
    } else {
      final twoMonthsAfterExpiration = membershipEndDate.add(
          const Duration(days: 2 * 30)); // Two months after membership ended
      if (currentDate.isBefore(twoMonthsAfterExpiration)) {
        return MembershipStatus.expired; // Membership expired
      } else {
        return MembershipStatus
            .inactive; // Membership inactive for 2 months after expiry
      }
    }
  }
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

@Entity()
class RenewalLog {
  @Id()
  int id;

  final member = ToOne<Member>(); // Name of the member who renewed

  @Property(type: PropertyType.date)
  DateTime renewalDate; // Date of renewal

  RenewalLog({
    this.id = 0,
    required this.renewalDate,
  });

  String getFormattedRenewalDate() {
    return DateFormat('MMM dd, yyyy').format(renewalDate);
  }
}
