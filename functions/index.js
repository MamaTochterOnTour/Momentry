/**
 * Firebase Cloud Functions V2 für Push-Benachrichtigungen
 * Stand: Dezember 2025
 */

const admin = require("firebase-admin");
admin.initializeApp();

const {
  onDocumentCreated,
  onDocumentUpdated,
} = require("firebase-functions/v2/firestore");

const {onRequest} = require("firebase-functions/v2/https");
const {onSchedule} = require("firebase-functions/v2/scheduler");

// ---------------------------------------------------
// Helper: Push senden
// ---------------------------------------------------
async function sendPush(fcmToken, title, body, data = {}) {
  if (!fcmToken) return;

  const message = {
    token: fcmToken,

    notification: {
      title,
      body,
    },

    data,

    android: {
      priority: "high",
      notification: {
        channelId: "high_importance_channel",
        sound: "default",
      },
    },

    apns: {
      payload: {
        aps: {
          alert: {
            title,
            body,
          },
          sound: "default",
        },
      },
    },
  };

  try {
    await admin.messaging().send(message);
    console.log(`Push gesendet an Token: ${fcmToken}`);
  } catch (err) {
    console.error("Fehler beim Senden der Push:", err);
  }
}

// ---------------------------------------------------
// 1. Kommentar-Benachrichtigung
// ---------------------------------------------------
exports.commentNotification = onDocumentCreated(
    "Comments/{commentId}",
    async (event) => {
      const comment = event.data.data();
      if (!comment) return;

      const postDoc = await admin
          .firestore()
          .collection("Posts")
          .doc(comment.postId)
          .get();
      if (!postDoc.exists) return;
      const post = postDoc.data();

      const postOwnerDoc = await admin
          .firestore()
          .collection("Users")
          .doc(post.uid)
          .get();
      if (!postOwnerDoc.exists) return;
      const postOwner = postOwnerDoc.data();
      if (!postOwner.fcmToken) return;

      const commenterDoc = await admin
          .firestore()
          .collection("Users")
          .doc(comment.userId)
          .get();
      const commenterUsername = commenterDoc.exists ? commenterDoc.data().username : "Jemand";

      await sendPush(
          postOwner.fcmToken,
          "💬 Neuer Kommentar",
          `${commenterUsername} hat deinen Beitrag kommentiert: "${comment.text}"`,
          {type: "comment", postId: comment.postId},
      );
    },
);

// ---------------------------------------------------
// 2. Like-Benachrichtigung
// ---------------------------------------------------
exports.likeNotification = onDocumentUpdated(
    "Posts/{postId}",
    async (event) => {
      const before = event.data.before.data();
      const after = event.data.after.data();
      if (!before || !after) return;

      const oldLikes = before.hearts || [];
      const currentLikes = after.hearts || [];

      const newLikes = currentLikes.filter(
          (uid) => !oldLikes.includes(uid),
      );

      if (newLikes.length === 0) return;

      const postOwnerDoc = await admin
          .firestore()
          .collection("Users")
          .doc(after.uid)
          .get();
      if (!postOwnerDoc.exists) return;
      const postOwner = postOwnerDoc.data();
      if (!postOwner.fcmToken) return;

      for (const likerUid of newLikes) {
        const likerDoc = await admin.firestore().collection("Users").doc(likerUid).get();
        const likerUsername = likerDoc.exists ? likerDoc.data().username: "Jemand";

        await sendPush(
            postOwner.fcmToken,
            "❤️ Neuer Like",
            `${likerUsername} hat deinen Reisemoment geliked`,
            {type: "like", postId: event.params.postId},
        );
      }
    },
);

// ---------------------------------------------------
// 3. Follow Notification
// ---------------------------------------------------
exports.followNotification = onDocumentCreated(
    "Follow/{followId}",
    async (event) => {
      const follow = event.data.data();
      if (!follow) return;

      const followerId = follow.followerId;
      const followingId = follow.followingId;

      // Sicherheitscheck: kein Self-Follow Push
      if (followerId === followingId) return;

      // User, der folgt
      const followerDoc = await admin
          .firestore()
          .collection("Users")
          .doc(followerId)
          .get();

      if (!followerDoc.exists) return;

      const followerData = followerDoc.data();
      const followerUsername = followerData?.username || "Jemand";

      // User, der gefolgt wird
      const followingDoc = await admin
          .firestore()
          .collection("Users")
          .doc(followingId)
          .get();

      if (!followingDoc.exists) return;

      const followingData = followingDoc.data();
      const fcmToken = followingData?.fcmToken;

      if (!fcmToken) return;

      await sendPush(
          fcmToken,
          "👤 Neuer Follower",
          `${followerUsername} begleitet jetzt deine Reise`,
          {
            type: "follow",
            followerId: followerId,
          },
      );
    },
);

// ---------------------------------------------------
// 4. Einmalige Push an alle User (Manuell triggerbar)
// ---------------------------------------------------
exports.sendOneTimeBroadcast = onRequest(async (req, res) => {
  try {
    const usersSnapshot = await admin.firestore().collection("Users").get();
    let sent = 0;

    for (const doc of usersSnapshot.docs) {
      const user = doc.data();
      if (!user || !user.fcmToken) continue;

      await sendPush(
          user.fcmToken,
          "🌍 Zeig uns deine Reise",
          "Poste deinen letzten Moment und werde wieder Teil der Community.",
          {type: "broadcast"},
      );

      sent++;
    }

    res.status(200).send(`Push an ${sent} User gesendet.`);
  } catch (err) {
    console.error("Broadcast Fehler:", err);
    res.status(500).send("Fehler beim Senden der Broadcast-Push.");
  }
},
);

// ---------------------------------------------------
// 5. Einmalige Push für App-Update (Manuell triggerbar)
// ---------------------------------------------------
exports.sendUpdateBroadcast = onRequest(async (req, res) => {
  try {
    const usersSnapshot = await admin.firestore().collection("Users").get();
    let sent = 0;

    for (const doc of usersSnapshot.docs) {
      const user = doc.data();
      if (!user || !user.fcmToken) continue;

      await sendPush(
          user.fcmToken,
          "📲 Neues Update ist da",
          "Neue Features warten auf dich – jetzt aktualisieren im App Store oder Google Play Store",
          {type: "update"},
      );

      sent++;
    }

    res.status(200).send(`Update-Push an ${sent} User gesendet.`);
  } catch (err) {
    console.error("Update Broadcast Fehler:", err);
    res.status(500).send("Fehler beim Senden des Update-Push.");
  }
});

// ---------------------------------------------------
// 6. Reply auf Kommentar
// ---------------------------------------------------
exports.replyNotification = onDocumentCreated(
    "Comments/{commentId}",
    async (event) => {
      const reply = event.data.data();
      if (!reply) return;

      // Nur Replies verarbeiten
      if (!reply.parentCommentId) return;

      // 🔥 Original-Kommentar holen
      const parentCommentSnap = await admin
          .firestore()
          .collection("Comments")
          .doc(reply.parentCommentId)
          .get();

      if (!parentCommentSnap.exists) return;

      const parentComment = parentCommentSnap.data();
      const targetUserId = parentComment.userId;

      // Kein Self-Push
      if (targetUserId === reply.userId) return;

      // 🔥 User, der die Reply bekommt
      const targetUserSnap = await admin
          .firestore()
          .collection("Users")
          .doc(targetUserId)
          .get();

      if (!targetUserSnap.exists) return;

      const targetUser = targetUserSnap.data();
      const fcmToken = targetUser?.fcmToken;

      if (!fcmToken) return;

      // 🔥 Replier Username holen
      const replierSnap = await admin
          .firestore()
          .collection("Users")
          .doc(reply.userId)
          .get();

      const replierName =
      replierSnap.exists && replierSnap.data().username ?
        replierSnap.data().username :
        "Jemand";

      // 🔥 Kommentartext (gekürzt für Push!)
      const originalText =
      parentComment.text && parentComment.text.length > 60 ?
        parentComment.text.substring(0, 60) + "..." :
        parentComment.text || "";

      await sendPush(
          fcmToken,
          "💬 Antwort auf deinen Kommentar",
          `${replierName}: "${originalText}"`,
          {
            type: "reply",
            postId: reply.postId,
            commentId: reply.parentCommentId,
          },
      );
    },
);

// ---------------------------------------------------
// 7. Kommentar / Reply Like Notification
// ---------------------------------------------------
exports.commentLikeNotification = onDocumentUpdated(
    "Comments/{commentId}",
    async (event) => {
      const before = event.data.before.data();
      const after = event.data.after.data();

      if (!before || !after) return;

      const beforeLikes = before.likes || [];
      const afterLikes = after.likes || [];

      // 🔥 nur neue Likes
      const newLikes = afterLikes.filter(
          (uid) => !beforeLikes.includes(uid),
      );

      if (newLikes.length === 0) return;

      const likerId = newLikes[0];
      const ownerId = after.userId;

      // kein Self-Push
      if (likerId === ownerId) return;

      // Owner holen
      const ownerSnap = await admin
          .firestore()
          .collection("Users")
          .doc(ownerId)
          .get();

      if (!ownerSnap.exists) return;

      const owner = ownerSnap.data();
      const fcmToken = owner?.fcmToken;
      if (!fcmToken) return;

      // Liker holen
      const likerSnap = await admin
          .firestore()
          .collection("Users")
          .doc(likerId)
          .get();

      const likerName =
      likerSnap.exists && likerSnap.data().username ?
        likerSnap.data().username :
        "Jemand";

      // 🔥 Kommentar oder Reply erkennen
      const isReply = !!after.parentCommentId;

      const title = "❤️ Neuer Like";

      const body = isReply ?
      `${likerName} hat deine Antwort geliked` :
      `${likerName} hat deinen Kommentar geliked`;

      await sendPush(
          fcmToken,
          title,
          body,
          {
            type: isReply ? "reply_like" : "comment_like",
            postId: after.postId,
            commentId: event.params.commentId,
            parentCommentId: after.parentCommentId || "",
          },
      );
    },
);

// ---------------------------------------------------
// 8. Q&A-Antwort
// ---------------------------------------------------
exports.qaAnswerNotification = onDocumentCreated(
    "Questions/{questionId}/Answers/{answerId}",
    async (event) => {
      const answer = event.data.data();
      if (!answer) return;

      const questionId = event.params.questionId;

      // 🔥 Frage holen
      const questionSnap = await admin
          .firestore()
          .collection("Questions")
          .doc(questionId)
          .get();

      if (!questionSnap.exists) return;

      const question = questionSnap.data();
      const questionOwnerId = question.userId;

      // Kein Self-Push
      if (questionOwnerId === answer.userId) return;

      // 🔥 Owner holen
      const ownerSnap = await admin
          .firestore()
          .collection("Users")
          .doc(questionOwnerId)
          .get();

      if (!ownerSnap.exists) return;

      const owner = ownerSnap.data();
      const fcmToken = owner?.fcmToken;
      if (!fcmToken) return;

      // 🔥 Answer User holen
      const userSnap = await admin
          .firestore()
          .collection("Users")
          .doc(answer.userId)
          .get();

      const username =
      userSnap.exists && userSnap.data().username ?
        userSnap.data().username :
        "Jemand";

      await sendPush(
          fcmToken,
          "❓ Neue Antwort",
          `${username} hat deine Frage im Q&A beantwortet`,
          {
            type: "qa_answer",
            questionId,
            answerId: event.params.answerId,
            fromUserId: answer.userId,
          },
      );
    },
);

// ---------------------------------------------------
// 8. Q&A-Reply
// ---------------------------------------------------
exports.qaReplyNotification = onDocumentCreated(
    "Questions/{questionId}/Answers/{answerId}/Replies/{replyId}",
    async (event) => {
      const reply = event.data.data();
      if (!reply) return;

      const {questionId, answerId} = event.params;

      // 🔥 Original Answer holen
      const answerSnap = await admin
          .firestore()
          .collection("Questions")
          .doc(questionId)
          .collection("Answers")
          .doc(answerId)
          .get();

      if (!answerSnap.exists) return;

      const answer = answerSnap.data();
      const answerOwnerId = answer.userId;

      // Kein Self-Push
      if (answerOwnerId === reply.userId) return;

      // 🔥 Owner holen
      const ownerSnap = await admin
          .firestore()
          .collection("Users")
          .doc(answerOwnerId)
          .get();

      if (!ownerSnap.exists) return;

      const owner = ownerSnap.data();
      const fcmToken = owner?.fcmToken;
      if (!fcmToken) return;

      // 🔥 Replier holen
      const replierSnap = await admin
          .firestore()
          .collection("Users")
          .doc(reply.userId)
          .get();

      const replierName =
      replierSnap.exists && replierSnap.data().username ?
        replierSnap.data().username :
        "Jemand";

      await sendPush(
          fcmToken,
          "💬 Neue Antwort",
          `${replierName} hat auf deine Antwort im Q&A geantwortet`,
          {
            type: "qa_reply",
            questionId,
            answerId,
            replyId: event.params.replyId,
            fromUserId: reply.userId,
          },
      );
    },
);

// ---------------------------------------------------
// 9. Reise startet heute
// ---------------------------------------------------
exports.tripStartReminder = onSchedule(
    {
      schedule: "5 0 * * *",
      timeZone: "Europe/Berlin",
    },
    async () => {
      const today = new Date();

      const startOfDay = new Date(today);
      startOfDay.setHours(0, 0, 0, 0);

      const endOfDay = new Date(today);
      endOfDay.setHours(23, 59, 59, 999);

      const trips = await admin
          .firestore()
          .collection("trips")
          .where("startDate", ">=", startOfDay)
          .where("startDate", "<=", endOfDay)
          .get();

      for (const tripDoc of trips.docs) {
        const trip = tripDoc.data();

        const userDoc = await admin
            .firestore()
            .collection("Users")
            .doc(trip.userId)
            .get();

        if (!userDoc.exists) continue;

        const user = userDoc.data();

        if (!user?.fcmToken) continue;

        await sendPush(
            user.fcmToken,
            "✈️ Deine Reise beginnt heute!",
            "Wir wünschen dir eine tolle Reise! Vergiss nicht, deine schönsten Momente mit der Community zu teilen.",
            {
              type: "trip_start",
            },
        );
      }
    },
);

// ---------------------------------------------------
// 10. Gruppenchat-Nachricht
// ---------------------------------------------------
exports.groupMessageNotification = onDocumentCreated(
    "groups/{groupId}/messages/{messageId}",
    async (event) => {
      const message = event.data.data();
      if (!message) return;

      const groupId = event.params.groupId;

      // Gruppe laden
      const groupSnap = await admin
          .firestore()
          .collection("groups")
          .doc(groupId)
          .get();

      if (!groupSnap.exists) return;

      const group = groupSnap.data();

      const members = group.members || [];
      const groupTitle = group.title || "Gruppe";

      // Absender laden
      const senderSnap = await admin
          .firestore()
          .collection("Users")
          .doc(message.userId)
          .get();

      const senderName =
        senderSnap.exists && senderSnap.data().username ?
          senderSnap.data().username :
          "Jemand";

      // Push an alle Mitglieder außer dem Absender
      for (const uid of members) {
        if (uid === message.userId) continue;

        const userSnap = await admin
            .firestore()
            .collection("Users")
            .doc(uid)
            .get();

        if (!userSnap.exists) continue;

        const user = userSnap.data();

        if (!user?.fcmToken) continue;

        await sendPush(
            user.fcmToken,
            `💬 ${groupTitle}`,
            `${senderName}: ${message.text}`,
            {
              type: "group_message",
              groupId: groupId,
            },
        );
      }
    },
);
