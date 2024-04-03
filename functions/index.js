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

// Set up Algolia
const {default: algoliasearch} = require("algoliasearch");
const algoliaClient = algoliasearch(
    functions.config().algolia.appid,
    functions.config().algolia.apikey,
);
const indexName = "TongTong";
const collectionIndex = algoliaClient.initIndex(indexName);

// define functions:collectionOnCreate
exports.collectionOnCreate = functions
    .region("asia-northeast2")
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
        // uid: data["uid"],
        // name: data["name"],
        content: data["contents"],
        // photoUrls: data["image"],
        // dateTime: data["dateTime"],
        // documentId: data["documnetId"],
        // anoym: data["anoym"],
        // commentsCount: data["commentsCount"],
      };
      collectionIndex.saveObject(record)
          .catch((res) => console.log("Error with: ", res));
    }
  }
};

// define functions:ticcleOnUpdate
exports.ticcleOnUpdate = functions
    .region("asia-northeast2")
    .firestore.document("Posts/{postsId}")
    .onUpdate(async (change, context) => {
      await updateDocumentInAlgolia(context.params.postsId, change);
    });


const updateDocumentInAlgolia = async (objectID, change) => {
  const before = change.before.data();
  const after = change.after.data();
  if (before && after) {
    const record = {objectID: objectID};
    let flag = false;
    if (before.content != after.content) {
      record.content = after.content;
      flag = true;
    }

    if (flag) {
      // update
      collectionIndex.partialUpdateObject(record)
          .catch((res) => console.log("Error with: ", res));
    }
  }
};

// define functions:ticcleOnDelete
exports.ticcleOnDelete = functions
    .region("asia-northeast2")
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
