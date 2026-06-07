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

// ---------------------------------------------------
// Helper: Push senden
// ---------------------------------------------------
async function sendPush(fcmToken, title, body, data = {}) {
  if (!fcmToken) return;

  const message = {
    token: fcmToken,
    notification: {title, body},
    data,
    apns: {
      payload: {
        aps: {
          alert: {title, body},
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
// 1. Willkommensnachricht
// ---------------------------------------------------
exports.sendWelcomeNotification = onDocumentCreated(
    "Users/{userId}",
    async (event) => {
      const user = event.data.data();
      if (!user || !user.fcmToken) return;

      await sendPush(
          user.fcmToken,
          "Willkommen bei Momentry!",
          "Wir freuen uns, dich auf deinen kommenden Reisen zu begleiten. Teile deine schönsten Erlebnisse und lass dich inspirieren!",
          {type: "welcome"},
      );
    },
);

// ---------------------------------------------------
// 2. Kommentar-Benachrichtigung
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
          "Neuer Kommentar auf deinen Beitrag",
          `${commenterUsername} hat deinen Beitrag kommentiert: "${comment.text}"`,
          {type: "comment", postId: comment.postId},
      );
    },
);

// ---------------------------------------------------
// 3. Like-Benachrichtigung
// ---------------------------------------------------
exports.likeNotification = onDocumentUpdated(
    "Posts/{postId}",
    async (event) => {
      const before = event.data.before.data();
      const after = event.data.after.data();
      if (!before || !after) return;

      const newLikes = after.hearts.filter((uid) => !before.hearts.includes(uid)) || [];
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
            "Jemand hat deinen Beitrag geliked",
            `${likerUsername} hat deinen Beitrag geliked!`,
            {type: "like", postId: event.params.postId},
        );
      }
    },
);

// ---------------------------------------------------
// 8. Follow Notification
// ---------------------------------------------------
exports.followNotification = onDocumentCreated(
    "Follow/{followId}",
    async (event) => {
      const follow = event.data.data();
      if (!follow) return;

      // User, der folgt
      const followerDoc = await admin
          .firestore()
          .collection("Users")
          .doc(follow.followerId)
          .get();
      if (!followerDoc.exists) return;
      let followerUsername = "Jemand";
      const followerData = followerDoc.data();
      if (followerData && followerData.username) {
        followerUsername = followerData.username;
      }

      // User, der gefolgt wird
      const followingDoc = await admin
          .firestore()
          .collection("Users")
          .doc(follow.followingId)
          .get();
      if (!followingDoc.exists || !followingDoc.data().fcmToken) return;

      await sendPush(
          followingDoc.data().fcmToken,
          "Neuer Follower",
          `${followerUsername} folgt dir jetzt!`,
          {type: "follow", followerId: follow.followerId},
      );
    },
);

// ---------------------------------------------------
// 9. Antwort auf Kommentar Benachrichtigung
// ---------------------------------------------------
exports.replyNotification = onDocumentCreated(
    "Comments/{commentId}",
    async (event) => {
      const comment = event.data.data();
      if (!comment || !comment.parentCommentId) return; // Nur Antworten berücksichtigen

      // Hole das übergeordnete Kommentar
      const parentCommentDoc = await admin
          .firestore()
          .collection("Comments")
          .doc(comment.parentCommentId)
          .get();

      if (!parentCommentDoc.exists) return;

      const parentComment = parentCommentDoc.data();
      const parentUserId = parentComment.userId;

      // Hole den User, der die Antwort bekommt
      const parentUserDoc = await admin
          .firestore()
          .collection("Users")
          .doc(parentUserId)
          .get();

      if (!parentUserDoc.exists || !parentUserDoc.data().fcmToken) return;

      // Hole Username des Repliers
      const replierDoc = await admin
          .firestore()
          .collection("Users")
          .doc(comment.userId)
          .get();

      const replierUsername = replierDoc.exists && replierDoc.data().username?
          replierDoc.data().username : "Jemand";

      await sendPush(
          parentUserDoc.data().fcmToken,
          "Neue Antwort auf deinen Kommentar",
          `${replierUsername} hat auf deinen Kommentar geantwortet: "${comment.text}"`,
          {type: "reply", postId: comment.postId, parentCommentId: comment.parentCommentId},
      );
    },
);

// ---------------------------------------------------
// Q&A-Board Antwort Benachrichtigung (Subcollection Answers)
// ---------------------------------------------------
exports.qaAnswerNotification = onDocumentCreated(
    "Questions/{questionId}/Answers/{answerId}",
    async (event) => {
      const answer = event.data.data();
      if (!answer) return;

      const questionId = event.params.questionId;

      const questionDoc = await admin
          .firestore()
          .collection("Questions")
          .doc(questionId)
          .get();

      if (!questionDoc.exists) return;

      const question = questionDoc.data();
      const questionOwnerId = question.userId;

      // Kein Self-Push
      if (questionOwnerId === answer.userId) return;

      const questionOwnerDoc = await admin
          .firestore()
          .collection("Users")
          .doc(questionOwnerId)
          .get();

      if (!questionOwnerDoc.exists) return;

      const questionOwner = questionOwnerDoc.data();

      if (!questionOwner.fcmToken) return;

      await sendPush(
          questionOwner.fcmToken,
          "Neue Antwort auf deine Frage",
          `${answer.username} hat auf deine Frage geantwortet.`,
          {
            type: "qaAnswer",
            questionId,
            answerId: event.params.answerId,
          },
      );
    },
);

// ---------------------------------------------------
// Q&A-Board Antwort Benachrichtigung (Subcollection Replies)
// ---------------------------------------------------
exports.qaReplyNotification = onDocumentCreated(
    "Questions/{questionId}/Answers/{answerId}/Replies/{replyId}",
    async (event) => {
      const reply = event.data.data();
      if (!reply) return;

      const {questionId, answerId} = event.params;

      const answerDoc = await admin
          .firestore()
          .collection("Questions")
          .doc(questionId)
          .collection("Answers")
          .doc(answerId)
          .get();

      if (!answerDoc.exists) return;

      const answer = answerDoc.data();

      const questionDoc = await admin
          .firestore()
          .collection("Questions")
          .doc(questionId)
          .get();

      if (!questionDoc.exists) return;

      const question = questionDoc.data();

      const recipients = new Set();

      // Besitzer der Frage
      if (question.userId !== reply.userId) {
        recipients.add(question.userId);
      }

      // Besitzer der Antwort
      if (answer.userId !== reply.userId) {
        recipients.add(answer.userId);
      }

      // Alle bisherigen Reply-Schreiber
      const repliesSnapshot = await admin
          .firestore()
          .collection("Questions")
          .doc(questionId)
          .collection("Answers")
          .doc(answerId)
          .collection("Replies")
          .get();

      repliesSnapshot.forEach((doc) => {
        const r = doc.data();

        if (
          r.userId &&
        r.userId !== reply.userId
        ) {
          recipients.add(r.userId);
        }
      });

      for (const uid of recipients) {
        const userDoc = await admin
            .firestore()
            .collection("Users")
            .doc(uid)
            .get();

        if (!userDoc.exists) continue;

        const user = userDoc.data();

        if (!user.fcmToken) continue;

        await sendPush(
            user.fcmToken,
            "Neue Aktivität im Q&A",
            `${reply.username} hat geantwortet.`,
            {
              type: "qaReply",
              questionId,
              answerId,
            },
        );
      }
    },
);

// ---------------------------------------------------
// Post gespeichert Benachrichtigung
// ---------------------------------------------------
exports.savedPostNotification = onDocumentUpdated(
    "Users/{userId}",
    async (event) => {
      const before = event.data.before.data();
      const after = event.data.after.data();

      if (!before || !after) return;
      if (!before.savedPosts) before.savedPosts = [];
      if (!after.savedPosts) after.savedPosts = [];

      // Neue gespeicherte Posts ermitteln
      const newSavedPosts = after.savedPosts.filter(
          (postId) => !before.savedPosts.includes(postId),
      );

      if (newSavedPosts.length === 0) return;

      const savingUserId = event.params.userId;

      for (const postId of newSavedPosts) {
        // Post-Dokument holen
        const postDoc = await admin.firestore().collection("Posts").doc(postId).get();
        if (!postDoc.exists) continue;
        const post = postDoc.data();

        const postOwnerId = post.uid;

        // Post-Besitzer holen
        const postOwnerDoc = await admin.firestore().collection("Users").doc(postOwnerId).get();
        if (!postOwnerDoc.exists || !postOwnerDoc.data().fcmToken) continue;

        const savingUserDoc = await admin.firestore().collection("Users").doc(savingUserId).get();
        const savingUsername = savingUserDoc.exists ? savingUserDoc.data().username : "Jemand";

        await sendPush(
            postOwnerDoc.data().fcmToken,
            "Jemand hat deinen Beitrag gespeichert",
            `${savingUsername} hat deinen Beitrag gespeichert!`,
            {type: "savedPost", postId},
        );
      }
    },
);

// ---------------------------------------------------
// 10. Einmalige Push an alle User (Manuell triggerbar)
// ---------------------------------------------------
const {onRequest} = require("firebase-functions/v2/https");

exports.sendOneTimeBroadcast = onRequest(async (req, res) => {
  try {
    const usersSnapshot = await admin.firestore().collection("Users").get();
    let sent = 0;

    for (const doc of usersSnapshot.docs) {
      const user = doc.data();
      if (!user || !user.fcmToken) continue;

      await sendPush(
          user.fcmToken,
          "Wir vermissen deine Beiträge 🌍",
          "Poste deinen Lieblingsort und markiere ihn mit #TopSpot. Zeig uns deine Welt!",
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
// Einmalige Push an alle User (Update verfügbar)
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
          "📲 Neues Update verfügbar!",
          "Bitte aktualisiere die App im App Store/ Play Store – neue Funktionen warten! ✨",
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
