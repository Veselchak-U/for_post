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
  final DateTime createdAt;
  final DateTime updatedAt;
  final String displayName;
  final String photoUrl;
  final String email;
  final String phone;

  factory MemberModel.fromJson(Map<String, dynamic> json) =>
      _$MemberModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberModelToJson(this);
}
