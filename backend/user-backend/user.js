const express = require('express');
const app = express();
const AWS = require('aws-sdk');
const jwt = require('jsonwebtoken');

AWS.config.update({
  region: 'ap-northeast-2', 
  accessKeyId: 'AKIAYRUU7OQTAQ3FKWXW',
  secretAccessKey: 'xtnthyZH2AxhT4rCbViV0ynvKGjA1NswdA7HTVxz'
}); // Replace with your desired AWS region

const dynamodb = new AWS.DynamoDB.DocumentClient();
var ddb = new AWS.DynamoDB({apiVersion: '2012-08-10'});
const tableName = 'users';

app.use(express.json()); // Parse JSON request bodies

// Route for login
app.post('/login', (req, res) => {
  const { email, password } = req.body;

  // Verify login credentials in DynamoDB
  // const params = {
  //   TableName: tableName,
  //   Key: {
  //     id: { N: '1' },
  //     email: { S: "test@gmail.com" }
  //   },
  //   ProjectionExpression: 'password' // Include only the password attribute in the response
  // };

  const params = {
    TableName: "users",
    FilterExpression: "email = :email",
    ExpressionAttributeValues: {
        ":email": email
    }
  };
  
  dynamodb.scan(params, (err, data) => {
    if (err) {
      console.error('Error while querying DynamoDB:', err);
      res.status(500).json({ error: 'An error occurred while verifying the login.' });
    } else {
      const user = data.Items[0];
      if (user && user.password === password) {
        // Generate JWT token
        const token = jwt.sign({ username: email }, 'your-secret-key', { expiresIn: '1h' });
        res.json({ token });
      } else {
        res.status(401).json({ error: 'Invalid username or password.' });
      }
    }
  });
});

// Define a route to test the DynamoDB connection
app.get('/test', (req, res) => {
  const params = {
    TableName: 'users',
    Item: {
      id: 2,
      email: 'test2@gmail.com',
      username: 'hansung',
      birth: '991002',
      password: '1234',
      profile_img_url: 'testURL',
      role: 1,
      created_at: '2023-06-17',
    },
  };

  dynamodb.put(params, (err, data) => {
    if (err) {
      console.error('Error adding data to DynamoDB:', err);
      res.status(500).send('Error adding data to DynamoDB');
    } else {
      console.log('Data added to DynamoDB successfully:', data);
      res.send('Data added to DynamoDB successfully');
    }
  });
});

app.get('/', async (req, res) => {

  res.status(200).json({ message: 'Healthy check success!' });

});

// Start the server
const port = 3000; // Change to your desired port number
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});