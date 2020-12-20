import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@CopyWith()
@JsonSerializable()
class MemberModel {
  const MemberModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.displayName,
    this.photoUrl,
    this.email,
    this.phone,
  });

  final String id;
  @JsonKey(nullable: true)
  final DateTime createdAt;
  @JsonKey(nullable: true)
  final DateTime updatedAt;
  final String displayName;
  @JsonKey(nullable: true)
  final String photoUrl;
  @JsonKey(nullable: true)
  final String email;
  @JsonKey(nullable: true)
  final String phone;

  // Empty user which represents an unauthenticated user.
  static const empty = MemberModel(
    id: '',
  );

  // Test user
  static const test = MemberModel(
    id: 'db2f755b-2098-4f43-8f3a-a8b698acfb8a',
    displayName: 'John Doe',
    photoUrl:
        'https://cdn.pixabay.com/photo/2013/07/13/09/47/negro-156005_960_720.png',
  );

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}
