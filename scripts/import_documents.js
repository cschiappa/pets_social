const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');
const data = require('./pet_tags.json');

const environmentFilePath = path.join(__dirname, '..', 'environment.json');

try {
  // Read the content of the file
  const fileContent = fs.readFileSync(environmentFilePath, 'utf8');

  // Parse the JSON content to access the SERVICE_ACCOUNT property
  const environmentData = JSON.parse(fileContent);
  const serviceAccountBase64 = environmentData.SERVICE_ACCOUNT;

  // Decode the base64 string to utf8
  const serviceAccountUtf8 = JSON.parse(Buffer.from(serviceAccountBase64, 'base64').toString('utf8'));

  admin.initializeApp({
            credential: admin.credential.cert(serviceAccountUtf8),
            databaseURL: 'https://pets-social-3d14e.firebaseio.com' 
          });
          
          const firestore = admin.firestore();

          

const petTagsData = data['pet-tags'];

const collectionName = 'pet-tags';

const importData = async () => {
  const batch = firestore.batch();

  Object.keys(petTagsData).forEach(animal => {
    const docRef = firestore.collection(collectionName).doc(animal);
    batch.set(docRef, {}); // Set an empty object as the value
  });

  await batch.commit();
  console.log('Data imported successfully!');
};

    importData();
} catch (error) {
  console.error('Error reading or parsing the environment file:', error);
}



