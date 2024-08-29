/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp({
  databaseURL: "https://(default).asia-northeast3.firebaseio.com", // Firebase Realtime Database URL
});

exports.addFieldToAllDocs = functions
    .region("asia-northeast3")
    .https.onRequest(async (req, res) => {
      const db = admin.database();
      const ref = db.ref("/Posts");

      const snapshot = await ref.once("value");

      const updates = {};

      snapshot.forEach((childSnapshot) => {
        const key = childSnapshot.key;
        updates[`${key}/anoymCount`] = 0; // 추가하고자 하는 새로운 필드와 값
      });

      await ref.update(updates);
      console.log("Field added to all documents.");

      res.send("Field added to all documents.");
    });

// Set up Algolia
const {default: algoliasearch} = require("algoliasearch");
const algoliaClient = algoliasearch(
    functions.config().algolia.appid,
    functions.config().algolia.apikey,
);
const indexName = "TongTong";
const collectionIndex = algoliaClient.initIndex(indexName);

// define functions:collectionOnCreate
exports.PostcollectionOnCreate = functions
    .region("asia-northeast3")
    .firestore.document("Posts/{postsId}")
    .onCreate(async (snapshot, context) => {
      await saveDocumentInAlgolia(snapshot);
    });

const saveDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const data = snapshot.data();
    console.log(snapshot.id);
    if (data) {
      const record = {
        objectID: snapshot.id,
        content: data["contents"],
      };
      collectionIndex.saveObject(record)
          .catch((res) => console.log("Error with: ", res));
    }
  }
};

const PracticeindexName = "TongTong_Practice";
const PracticecollectionIndex = algoliaClient.initIndex(PracticeindexName);

exports.PracticecollectionOnCreate = functions
    .region("asia-northeast3")
    .firestore.document("Practices/{practicesId}")
    .onCreate(async (snapshot, context) => {
      await savePracticeDocumentInAlgolia(snapshot);
    });

const savePracticeDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const data = snapshot.data();
    console.log(snapshot.id);
    if (data) {
      const record = {
        objectID: snapshot.id,
        content: data["contents"],
      };
      PracticecollectionIndex.saveObject(record)
          .catch((res) => console.log("Error with: ", res));
    }
  }
};

const RestaurantindexName = "TongTong_Restaurant";
const RestaurantcollectionIndex = algoliaClient.initIndex(RestaurantindexName);

exports.RestaurantcollectionOnCreate = functions
    .region("asia-northeast3")
    .firestore.document("Restaurants/{restaurantsId}")
    .onCreate(async (snapshot, context) => {
      await saveRestaurantDocumentInAlgolia(snapshot);
    });

const saveRestaurantDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const data = snapshot.data();
    console.log(snapshot.id);
    if (data) {
      const record = {
        objectID: snapshot.id,
        content: data["contents"],
      };
      RestaurantcollectionIndex.saveObject(record)
          .catch((res) => console.log("Error with: ", res));
    }
  }
};

const KnowhowindexName = "TongTong_Knowhow";
const KnowhowcollectionIndex = algoliaClient.initIndex(KnowhowindexName);

exports.KnowhowcollectionOnCreate = functions
    .region("asia-northeast3")
    .firestore.document("Knowhow/{knowhowId}")
    .onCreate(async (snapshot, context) => {
      await saveKnowhowDocumentInAlgolia(snapshot);
    });

const saveKnowhowDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const data = snapshot.data();
    console.log(snapshot.id);
    if (data) {
      const record = {
        objectID: snapshot.id,
        content: data["contents"],
      };
      KnowhowcollectionIndex.saveObject(record)
          .catch((res) => console.log("Error with: ", res));
    }
  }
};

const RepairindexName = "TongTong_Repair";
const RepaircollectionIndex = algoliaClient.initIndex(RepairindexName);

exports.RepaircollectionOnCreate = functions
    .region("asia-northeast3")
    .firestore.document("Repair/{repairId}")
    .onCreate(async (snapshot, context) => {
      await saveRepairDocumentInAlgolia(snapshot);
    });

const saveRepairDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const data = snapshot.data();
    console.log(snapshot.id);
    if (data) {
      const record = {
        objectID: snapshot.id,
        content: data["contents"],
      };
      RepaircollectionIndex.saveObject(record)
          .catch((res) => console.log("Error with: ", res));
    }
  }
};

const LightningindexName = "TongTong_Lightning";
const LightningcollectionIndex = algoliaClient.initIndex(LightningindexName);

exports.LightningcollectionOnCreate = functions
    .region("asia-northeast3")
    .firestore.document("Lightning/{lightningId}")
    .onCreate(async (snapshot, context) => {
      await saveLightningDocumentInAlgolia(snapshot);
    });

const saveLightningDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const data = snapshot.data();
    console.log(snapshot.id);
    if (data) {
      const record = {
        objectID: snapshot.id,
        content: data["contents"],
      };
      LightningcollectionIndex.saveObject(record)
          .catch((res) => console.log("Error with: ", res));
    }
  }
};

// define functions:ticcleOnUpdate
// exports.ticcleOnUpdate = functions
//     .region("asia-northeast2")
//     .firestore.document("Posts/{postsId}")
//     .onUpdate(async (change, context) => {
//       await updateDocumentInAlgolia(context.params.postsId, change);
//     });


// const updateDocumentInAlgolia = async (objectID, change) => {
//   const before = change.before.data();
//   const after = change.after.data();
//   if (before && after) {
//     const record = {objectID: objectID};
//     let flag = false;
//     if (before.content != after.content) {
//       record.content = after.content;
//       flag = true;
//     }

//     if (flag) {
//       // update
//       collectionIndex.partialUpdateObject(record)
//           .catch((res) => console.log("Error with: ", res));
//     }
//   }
// };

// define functions:ticcleOnDelete
exports.PostticcleOnDelete = functions
    .region("asia-northeast3")
    .firestore.document("Posts/{postsId}")
    .onDelete(async (snapshot, context) => {
      await deleteDocumentInAlgolia(snapshot);
    });

const deleteDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const objectID = snapshot.id;
    collectionIndex.deleteObject(objectID)
        .catch((res) => console.log("Error with: ", res));
  }
};

exports.PracticeticcleOnDelete = functions
    .region("asia-northeast3")
    .firestore.document("Practices/{practicesId}")
    .onDelete(async (snapshot, context) => {
      await deletePracticeDocumentInAlgolia(snapshot);
    });

const deletePracticeDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const objectID = snapshot.id;
    PracticecollectionIndex.deleteObject(objectID)
        .catch((res) => console.log("Error with: ", res));
  }
};

exports.RestaurantticcleOnDelete = functions
    .region("asia-northeast3")
    .firestore.document("Restaurants/{restaurantsId}")
    .onDelete(async (snapshot, context) => {
      await deleteRestaurantDocumentInAlgolia(snapshot);
    });

const deleteRestaurantDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const objectID = snapshot.id;
    RestaurantcollectionIndex.deleteObject(objectID)
        .catch((res) => console.log("Error with: ", res));
  }
};

exports.KnowhowticcleOnDelete = functions
    .region("asia-northeast3")
    .firestore.document("Knowhow/{knowhowId}")
    .onDelete(async (snapshot, context) => {
      await deleteKnowhowDocumentInAlgolia(snapshot);
    });

const deleteKnowhowDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const objectID = snapshot.id;
    KnowhowcollectionIndex.deleteObject(objectID)
        .catch((res) => console.log("Error with: ", res));
  }
};

exports.RepairticcleOnDelete = functions
    .region("asia-northeast3")
    .firestore.document("Repair/{repairId}")
    .onDelete(async (snapshot, context) => {
      await deleteRepairDocumentInAlgolia(snapshot);
    });

const deleteRepairDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const objectID = snapshot.id;
    RepaircollectionIndex.deleteObject(objectID)
        .catch((res) => console.log("Error with: ", res));
  }
};

exports.LightningticcleOnDelete = functions
    .region("asia-northeast3")
    .firestore.document("Lightning/{lightningId}")
    .onDelete(async (snapshot, context) => {
      await deleteLightningDocumentInAlgolia(snapshot);
    });

const deleteLightningDocumentInAlgolia = async (snapshot) => {
  if (snapshot.exists) {
    const objectID = snapshot.id;
    LightningcollectionIndex.deleteObject(objectID)
        .catch((res) => console.log("Error with: ", res));
  }
};

