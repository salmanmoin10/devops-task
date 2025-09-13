const express = require('express');
const path = require('path');
const fs = require('fs');  // For file existence check

const app = express();

app.get('/', (req, res) => {
  const filePath = path.join(__dirname, 'logoswayatt.png');
  console.log(`[INFO] Attempting to serve file from: ${filePath}`);
  if (!fs.existsSync(filePath)) {
    console.error('[ERROR] File not found');
    return res.status(404).send('File not found');
  }
  res.sendFile(filePath, (err) => {
    if (err) {
      console.error('[ERROR] Error sending file:', err);
      res.status(500).send('Internal Server Error');
    }
  });
});

const port = process.env.PORT || 3000;
app.listen(port, '0.0.0.0', () => {  // Bind to 0.0.0.0 for Cloud Run
  console.log(`[INFO] Server running on 0.0.0.0:${port}`);
});
