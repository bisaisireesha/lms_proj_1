import 'dart:convert';

class User {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? avatarUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? phoneNumber;
  final DateTime? lastLoginAt;
  final Map<String, dynamic> preferences;
  final List<String> enrolledCourses;
  final UserProfile? profile;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.avatarUrl,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.phoneNumber,
    this.lastLoginAt,
    this.preferences = const {},
    this.enrolledCourses = const [],
    this.profile,
  }) : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString(),
      'avatarUrl': avatarUrl,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'phoneNumber': phoneNumber,
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'preferences': preferences,
      'enrolledCourses': enrolledCourses,
      'profile': profile?.toMap(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: UserRole.values.firstWhere(
        (role) => role.toString() == map['role'],
        orElse: () => UserRole.user,
      ),
      avatarUrl: map['avatarUrl'],
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null 
          ? DateTime.parse(map['updatedAt']) 
          : DateTime.now(),
      phoneNumber: map['phoneNumber'],
      lastLoginAt: map['lastLoginAt'] != null 
          ? DateTime.parse(map['lastLoginAt']) 
          : null,
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
      enrolledCourses: List<String>.from(map['enrolledCourses'] ?? []),
      profile: map['profile'] != null 
          ? UserProfile.fromMap(map['profile']) 
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? id,
    String? email,
    String? name,
    UserRole? role,
    String? avatarUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? phoneNumber,
    DateTime? lastLoginAt,
    Map<String, dynamic>? preferences,
    List<String>? enrolledCourses,
    UserProfile? profile,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      phoneNumber: phoneNumber ?? this.phoneNumber,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      profile: profile ?? this.profile,
    );
  }

  bool get isAdmin => role == UserRole.admin;
  bool get isUser => role == UserRole.user;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role)';
  }
}
enum UserRole { 
  admin, 
  user, 
  instructor,
  moderator,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.user:
        return 'Student';
      case UserRole.instructor:
        return 'Instructor';
      case UserRole.moderator:
        return 'Moderator';
    }
  }
}

class UserProfile {
  final String bio;
  final String? company;
  final String? jobTitle;
  final String? location;
  final String? website;
  final List<String> skills;
  final Map<String, dynamic> socialLinks;
  UserProfile({
    this.bio = '',
    this.company,
    this.jobTitle,
    this.location,
    this.website,
    this.skills = const [],
    this.socialLinks = const {},
  });
  Map<String, dynamic> toMap() {
    return {
      'bio': bio,
      'company': company,
      'jobTitle': jobTitle,
      'location': location,
      'website': website,
      'skills': skills,
      'socialLinks': socialLinks,
    };
  }
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      bio: map['bio'] ?? '',
      company: map['company'],
      jobTitle: map['jobTitle'],
      location: map['location'],
      website: map['website'],
      skills: List<String>.from(map['skills'] ?? []),
      socialLinks: Map<String, dynamic>.from(map['socialLinks'] ?? {}),
    );
  }
  UserProfile copyWith({
    String? bio,
    String? company,
    String? jobTitle,
    String? location,
    String? website,
    List<String>? skills,
    Map<String, dynamic>? socialLinks,
  }) {
    return UserProfile(
      bio: bio ?? this.bio,
      company: company ?? this.company,
      jobTitle: jobTitle ?? this.jobTitle,
      location: location ?? this.location,
      website: website ?? this.website,
      skills: skills ?? this.skills,
      socialLinks: socialLinks ?? this.socialLinks,
    );
  }
}