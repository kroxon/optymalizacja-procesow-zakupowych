const express = require('express');
const app = express();
const port = 8080; 

app.use(express.static('.'));

app.listen(port, () => {
  console.log(`Serwer statycznych plików działa na http://localhost:${port}`);
});