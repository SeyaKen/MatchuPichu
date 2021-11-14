import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp(functions.config().firebase);
export const firestore = admin.firestore();
const db = admin.firestore();

exports.deleteUser = functions
    .region("asia-northeast1")
    .firestore.document("delete_users/{docId}")
    .onCreate(async (snap, context) => {
      const deleteDocument = snap.data();
      const uid = deleteDocument.uid;

      // Authenticationのユーザーを削除する
      await admin.auth().deleteUser(uid);
    });

export const createNotifications = functions.region('asia-northeast1').firestore.
    document("/osirase/{osirase}")
    .onCreate( async (snapshot: { data: () => any; }, context: any) => {
        // データベースのお知らせを更新する
        firestore.collection('user').get().then((docs) => {
              if (!docs.empty) {
                  docs.docs.forEach((element) =>
                    element.ref
                        .update({'osirase': true})
                  );
                }
            });
    });

    export const ninshouNotifications = functions.region('asia-northeast1').firestore.
    document("/user/{users}")
    .onUpdate( async (change, context: any) => {
      const doc = change.after.data();
      const doccontent = firestore.collection("user").doc(doc['uid']);
      doccontent.get().then(function(docc: { exists: boolean; data: () => any; }){
        const kakuninbool = docc.data()['kakuninbool'];
        const fcmToken = doccontent.collection("token").doc('token');
        fcmToken.get().then(function(doccc: { exists: boolean; data: () => any; }){
          const fcmToken = doccc.data()['token'];
          if (kakuninbool){
            pushNotification(fcmToken, '本人・年齢確認について', '本人・年齢確認が終了しました。');
            console.log("成功認証");
          }
        }).catch((error) => {
          console.log("エラー身分証明1:", error);
        });
      }).catch((error) => {
        console.log("エラー身分証明2:", error);
      });
    });

// 新規依頼作時
export const createMessage = functions.region('asia-northeast1').firestore.
    document("/chatrooms/{chatroom}/chats/{chat}")
    .onCreate( async (snapshot: { data: () => any; }, context: any) => {
      // ここにmessageのデータが入っている(senderId,senderName,receiverId,content)
      const message = snapshot.data();
      const receiverRef = firestore.collection("user").doc(message["sendTo"]);
      const fcmToken = receiverRef.collection('token').doc('token');
      fcmToken.get().then(function(doccc: { exists: boolean; data: () => any; }){
      const fcmToken = doccc.data()['token'];
      receiverRef.get().then(function(doc: { exists: boolean; data: () => any; }){
        if (doc.exists === true) {
        const receiver = doc.data();
        const badge = receiver["notifications"] + 1;
        const senderName = message["senderName"];
        const content = message["message"];
        // 通知のタイトル
        const title = senderName;
        // 通知の内容
        const body = content;
        const nyuusitu = db.collection('chatrooms').doc(message['chatRoomId']);
        nyuusitu.get().then(function(docc: { exists: boolean; data: () => any; }){
          // 送る相手のデータ
          const nyuusi = docc.data();
          const nyuus = nyuusi[`${message['sendTo']}nyuusitu`];
          const mute = nyuusi[`${message['sendTo']}mute`];
          if (!nyuus && !mute) {
            receiverRef.update({'notifications': badge});
            sendPushNotification(fcmToken, title, body, badge.toString());
          }
          console.log("成功！1");
        }).catch((error) => {
            console.log("エラー1:", error);
          });
        }
      }).catch((error) => {
        console.log("エラー2:", error);
      }).catch((error) => {
        console.log("エラー3:", error);
      });
    }); 
  });

// プッシュ通知を送る関数
const sendPushNotification =
function( token:string, title:string, body:string, badge:string) {
  const payload = {
    notification: {
      title: title,
      body: body,
      badge: badge,
      sound: "default",
    },
  };
  const option = {
    priority: "high",
  };
  // ここで実際に通知を送信している
  admin.messaging().sendToDevice(token, payload, option);
};

// プッシュ通知を送る関数
const pushNotification =
function( token:string, title:string, body:string) {
  const payload = {
    notification: {
      title: title,
      body: body,
      sound: "default",
    },
  };
  const option = {
    priority: "high",
  };
  // ここで実際に通知を送信している
  admin.messaging().sendToDevice(token, payload, option);
};

