const express = require('express');
const app = express();
// const dotenv = require('dotenv');
require('dotenv').config();



// Read environment variables from ConfigMap (populated in Kubernetes)
const appName = process.env.APP_NAME || "testing purpose";;
const appVersion = process.env.APP_VERSION || "4.0.0";;

// Define a route for the welcome page
app.get('/', (req, res) => {
    res.send(`<h1>Welcome to ${appName}!</h1><p>This is version ${appVersion} of the application.</p>`);
});
// Health check route (Liveness probe)
app.get('/health', (req, res) => {
    res.status(200).send('OK');
});


// Readiness check route
app.get('/ready', (req, res) => {
    res.status(200).send('Ready');
   });


// Start the server on port 3000 only if this module is run directly
if (require.main === module) {
    const port = 3000;
    app.listen(port, () => {
        console.log(`Server listening on http://localhost:${port}`);
    });
}

module.exports = app; // Export the app for testing