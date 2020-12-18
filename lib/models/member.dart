import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class MemberModel {
  MemberModel({
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

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}
