// ✅ INI yang boleh digunakan di Spark Plan
const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.deleteAuthUser = functions.https.onCall(async (data, context) => {
  if (!context.auth || context.auth.token.role !== "owner") {
    throw new functions.https.HttpsError("permission-denied", "Only owner can delete users");
  }

  const uid = data.uid;

  try {
    await admin.auth().deleteUser(uid);
    return { success: true };
  } catch (error) {
    console.error("Error deleting user:", error);
    throw new functions.https.HttpsError("internal", error.message);
  }
});
