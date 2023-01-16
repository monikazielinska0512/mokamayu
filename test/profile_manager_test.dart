import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mokamayu/models/friendship_status.dart';
import 'package:mokamayu/models/user.dart';
import 'package:mokamayu/services/authentication/auth.dart';
import 'package:mokamayu/services/managers/managers.dart';

class MockUser extends Mock implements User {
  @override
  String get uid => "current_user_uid";

  @override
  Future<void> updateDisplayName(String? displayName) async {}

  @override
  Future<void> updatePhotoURL(String? photoPath) async {}
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  User? get currentUser => MockUser();
}

void main() {
  late ProfileManager profileManager;
  late FakeFirebaseFirestore firestore;

  group('profile manager test', () {
    setUp(() async {
      firestore = FakeFirebaseFirestore();
      profileManager = ProfileManager.withParameters(
          authService: AuthService.withAuth(auth: MockFirebaseAuth()),
          firestore: firestore);
      profileManager.createUser('bob@test.com', 'bob', 'current_user_uid');
      await firestore.collection('users').doc('other_user_uid').set({
        'uid': 'other_user_uid',
        'username': 'ana',
        'email': 'ana@test.com',
        'privateProfile': true,
      });
    });

    test("get current user data", () async {
      UserData? obtainedCurrentUserData =
          await profileManager.getCurrentUserData();

      expect(obtainedCurrentUserData?.uid, 'current_user_uid');
      expect(obtainedCurrentUserData?.username, 'bob');
      expect(obtainedCurrentUserData?.profilePicture, null);
      expect(obtainedCurrentUserData?.profileName, null);
      expect(obtainedCurrentUserData?.email, 'bob@test.com');
      expect(obtainedCurrentUserData?.privateProfile, false);
    });

    test("get other user data", () async {
      UserData? obtainedUserData =
          await profileManager.getUserData('other_user_uid');

      expect(obtainedUserData?.username, 'ana');
      expect(obtainedUserData?.email, 'ana@test.com');
      expect(obtainedUserData?.privateProfile, true);
    });

    test('edit user data', () async {
      await profileManager.updateProfileName('Bob Baker');
      await profileManager.updateProfilePicture('path_to_picture');
      UserData? obtainedCurrentUserData =
          await profileManager.getCurrentUserData();

      expect(obtainedCurrentUserData?.profileName, 'Bob Baker');
      expect(obtainedCurrentUserData?.profilePicture, 'path_to_picture');
    });
  });

  group('friend invite test', () {
    setUp(() async {
      firestore = FakeFirebaseFirestore();
      profileManager = ProfileManager.withParameters(
          authService: AuthService.withAuth(auth: MockFirebaseAuth()),
          firestore: firestore);
      profileManager.createUser('bob@test.com', 'bob', 'current_user_uid');
      await firestore.collection('users').doc('other_user_uid').set({
        'uid': 'other_user_uid',
        'username': 'ana',
        'email': 'ana@test.com',
        'privateProfile': true
      });
    });

    test('send a friend request', () async {
      await profileManager.sendFriendInvite(UserData(
          uid: 'other_user_uid', username: 'ana', email: 'ana@test.com'));
      UserData? invitedFriend =
          await profileManager.getUserData('other_user_uid');
      UserData? currentUser = await profileManager.getCurrentUserData();

      expect(currentUser?.friends?.first, {
        "id": invitedFriend?.uid,
        "status": FriendshipState.INVITE_PENDING.toString()
      });
      expect(invitedFriend?.friends?.first, {
        "id": currentUser?.uid,
        "status": FriendshipState.RECEIVED_INVITE.toString()
      });
    });

    test('cancel sending friend request', () async {
      await profileManager.sendFriendInvite(UserData(
          uid: 'other_user_uid', username: 'ana', email: 'ana@test.com'));
      UserData? invitedFriend =
          await profileManager.getUserData('other_user_uid');
      UserData? currentUser = await profileManager.getCurrentUserData();

      profileManager.cancelFriendInvite(invitedFriend!);

      expect(currentUser?.friends, List.empty());
      expect(invitedFriend.friends, List.empty());
    });

    group('handle received invites', () {
      UserData? currentUser;
      UserData? potentialFriend;

      setUp(() async {
        await firestore.collection('users').doc('current_user_uid').set({
          'uid': 'current_user_uid',
          'username': 'bob',
          'email': 'bob@test.com',
          'privateProfile': false,
          'friends': [
            {
              "id": 'other_user_uid',
              "status": FriendshipState.RECEIVED_INVITE.toString()
            }
          ]
        });

        await firestore.collection('users').doc('other_user_uid').set({
          'uid': 'other_user_uid',
          'username': 'ana',
          'email': 'ana@test.com',
          'privateProfile': true,
          'friends': [
            {
              "id": 'current_user_uid',
              "status": FriendshipState.INVITE_PENDING.toString()
            }
          ]
        });

        currentUser = await profileManager.getCurrentUserData();
        potentialFriend = await profileManager.getUserData('other_user_uid');
      });

      test('accept invite', () {
        profileManager.acceptFriendInvite(potentialFriend!);

        expect(currentUser?.friends?.first, {
          "id": potentialFriend?.uid,
          "status": FriendshipState.FRIENDS.toString()
        });
        expect(potentialFriend?.friends?.first, {
          "id": currentUser?.uid,
          "status": FriendshipState.FRIENDS.toString()
        });
      });

      test('reject invite', () {
        profileManager.rejectFriendInvite(potentialFriend!);

        expect(currentUser?.friends, List.empty());
        expect(potentialFriend?.friends, List.empty());
      });
    });
  });
}
