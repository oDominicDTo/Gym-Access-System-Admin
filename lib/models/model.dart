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

  bool checkedIn = false;

  final attendance = ToMany<Attendance>();

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
        required this.checkedIn,
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
  @Id()
  int id;

  @Property(type: PropertyType.date)
  DateTime checkInTime;

  @Property(type: PropertyType.date)
  DateTime? checkOutTime; // Nullable DateTime

  @Property(type: PropertyType.int)
  int memberId; // Member ID

  Attendance({
    this.id = 0,
    required this.checkInTime,
    DateTime? checkOutTime,
    required this.memberId, // Member ID
  }) : checkOutTime = checkOutTime ?? DateTime(2000); // Set default if null
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
  @override
  String toString() {
    return typeName; // Or any other representation you prefer
  }
}


@Entity()
class RenewalLog {
  @Id()
  int id;

  final member = ToOne<Member>(); // Name of the member who renewed

  @Property(type: PropertyType.date)
  DateTime renewalDate; // Date of renewal

  @Property()
  int addedDurationDays;

  RenewalLog({
    this.id = 0,
    required this.renewalDate,
    required this.addedDurationDays,
  });

  String getFormattedRenewalDate() {
    return DateFormat('MMM dd, yyyy').format(renewalDate);
  }
}

@Entity()
class UserFeedback {
  @Id()
  int id;

  @Property(type: PropertyType.date)
  DateTime submissionTime;

  final String feedbackText;
  final String? category; // Categories could be UI, Functionality, Performance, etc.
  final String? name; // Optional: User's name
  final String? title;
  final bool isUser;

  UserFeedback({
    this.id = 0,
    required this.submissionTime,
    required this.feedbackText,
    required this.category,
    required this.title,
    required this.isUser,
    this.name,
  });
}

@Entity()
class CardChangeLog {
  @Id()
  int id;

  String entityType; // Type of entity: 'member' or 'admin'

  String entityName; // Name of the entity (member or admin)

  @Property(type: PropertyType.date)
  DateTime changeDate; // Date when the card was changed

  CardChangeLog({
    this.id = 0,
    required this.entityType,
    required this.entityName,
    required this.changeDate,
  });
}
@Entity()
class AdminRenewalLog {
  @Id()
  int id;

  @Property(type: PropertyType.date)
  DateTime renewalDate; // Date of renewal

  String memberName; // ID of the member who renewed
  String adminName; // ID of the admin who performed the action
  String membershipType; // ID of the membership type
  int addedDurationDays; // Number of days added to the membership
  double amount; // Amount paid for membership renewal

  AdminRenewalLog({
    this.id = 0,
    required this.renewalDate,
    required this.memberName,
    required this.adminName,
    required this.membershipType,
    required this.addedDurationDays,
    required this.amount,
  });

  String getFormattedRenewalDate() {
    return DateFormat('MMM dd, yyyy').format(renewalDate);
  }
}

@Entity()
class NewMemberLog {
  @Id()
  int id;

  @Property(type: PropertyType.date)
  DateTime creationDate; // Date of creation

  String memberName; // ID of the new member
  String adminName; // ID of the admin who added the member
  String membershipType; // ID of the membership type
  double amount; // Amount paid for new membership

  NewMemberLog({
    this.id = 0,
    required this.creationDate,
    required this.memberName,
    required this.adminName,
    required this.membershipType,
    required this.amount,
  });

  String getFormattedCreationDate() {
    return DateFormat('MMM dd, yyyy').format(creationDate);
  }
}

