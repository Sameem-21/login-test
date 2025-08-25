const express = require('express');
const sql = require('mssql');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.urlencoded({ extended: true }));

const config = {
  user: 'admin',
  password: 'Passw0rd!23',
  server: 'localhost',
  database: 'sam',
  options: {
    encrypt: false,
    trustServerCertificate: true
  }
};

app.post('/login', async (req, res) => {
  try {
    await sql.connect(config);
    const { username, password } = req.body;
    await sql.query`INSERT INTO [user] (username, password) VALUES (${username}, ${password})`;
    res.send('User inserted!');
  } catch (err) {
    console.error(err);
    res.status(500).send('Error inserting user');
  }
});

app.listen(3000, () => console.log('Server running on port 3000'));
