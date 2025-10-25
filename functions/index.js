const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// Cloud Function to trigger console log/notification when new post is added
exports.onPostCreated = functions.firestore
  .document('posts/{postId}')
  .onCreate(async (snap, context) => {
    const postData = snap.data();
    const postId = context.params.postId;
    
    // Console log as requested in the task
    console.log('🎉 NEW POST NOTIFICATION 🎉');
    console.log(`📝 Post ID: ${postId}`);
    console.log(`👤 Author: ${postData.username}`);
    console.log(`💬 Content: ${postData.content}`);
    console.log(`⏰ Created: ${new Date().toISOString()}`);
    console.log('================================');
    
    // Optional: Update post statistics
    try {
      await admin.firestore().collection('stats').doc('posts').set({
        totalPosts: admin.firestore.FieldValue.increment(1),
        lastPostAt: admin.firestore.FieldValue.serverTimestamp(),
        lastPostBy: postData.username
      }, { merge: true });
      
      console.log('📊 Post statistics updated');
    } catch (error) {
      console.error('❌ Error updating statistics:', error);
    }
    
    return null;
  });

// Cloud Function to handle post updates
exports.onPostUpdated = functions.firestore
  .document('posts/{postId}')
  .onUpdate(async (change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();
    const postId = context.params.postId;
    
    console.log('✏️ POST UPDATED NOTIFICATION ✏️');
    console.log(`📝 Post ID: ${postId}`);
    console.log(`👤 Author: ${afterData.username}`);
    console.log(`📝 Old Content: "${beforeData.content}"`);
    console.log(`📝 New Content: "${afterData.content}"`);
    console.log(`⏰ Updated: ${new Date().toISOString()}`);
    console.log('================================');
    
    return null;
  });

// Cloud Function to handle post deletions
exports.onPostDeleted = functions.firestore
  .document('posts/{postId}')
  .onDelete(async (snap, context) => {
    const postData = snap.data();
    const postId = context.params.postId;
    
    console.log('🗑️ POST DELETED NOTIFICATION 🗑️');
    console.log(`📝 Post ID: ${postId}`);
    console.log(`👤 Author: ${postData.username}`);
    console.log(`💬 Content: "${postData.content}"`);
    console.log(`⏰ Deleted: ${new Date().toISOString()}`);
    console.log('================================');
    
    // Update statistics
    try {
      await admin.firestore().collection('stats').doc('posts').set({
        totalPosts: admin.firestore.FieldValue.increment(-1),
        lastDeletedAt: admin.firestore.FieldValue.serverTimestamp(),
        lastDeletedBy: postData.username
      }, { merge: true });
      
      console.log('📊 Post statistics updated after deletion');
    } catch (error) {
      console.error('❌ Error updating statistics:', error);
    }
    
    return null;
  });

// Cloud Function to handle new user registration
exports.onUserCreated = functions.firestore
  .document('users/{userId}')
  .onCreate(async (snap, context) => {
    const userData = snap.data();
    const userId = context.params.userId;
    
    console.log('👋 NEW USER REGISTERED 👋');
    console.log(`🆔 User ID: ${userId}`);
    console.log(`📧 Email: ${userData.email}`);
    console.log(`👤 Username: ${userData.username}`);
    console.log(`⏰ Registered: ${new Date().toISOString()}`);
    console.log('================================');
    
    // Update user statistics
    try {
      await admin.firestore().collection('stats').doc('users').set({
        totalUsers: admin.firestore.FieldValue.increment(1),
        lastUserRegistered: userData.username,
        lastRegistrationAt: admin.firestore.FieldValue.serverTimestamp()
      }, { merge: true });
      
      console.log('📊 User statistics updated');
    } catch (error) {
      console.error('❌ Error updating user statistics:', error);
    }
    
    return null;
  });