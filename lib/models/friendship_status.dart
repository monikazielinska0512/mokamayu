enum FriendshipState {
  STRANGERS,
  FRIENDS,
  // Our invite is waiting for the other person's response.
  INVITE_PENDING,
  // We received a friend invite but haven't responded yet.
  RECEIVED_INVITE
}