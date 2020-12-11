const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sharedNotePushNotification = functions.https.onCall((data, context) => {
    console.log("Receiver of notification", data.uid);
    const payload = {
        notification: {
            title: data.note_title,
            body: data.note_body,
        },
        data: {
            click_action: "FLUTTER_NOTIFICATION_CLICK",
        }
    }

    return admin.messaging().sendToDevice(data.token, payload);

});
