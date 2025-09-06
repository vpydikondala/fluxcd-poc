const express = require('express');
const app = express();
const port = process.env.PORT || 80;

app.get('/', (req, res) => {
  res.send('Hello from myapp - updated!');
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});

