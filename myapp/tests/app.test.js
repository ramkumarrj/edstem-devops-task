// tests/app.test.js
const request = require('supertest');
const app = require('../app'); // Adjust the path if necessary

describe('GET /', () => {
    it('should return welcome message', async () => {
        const response = await request(app).get('/');
        expect(response.statusCode).toBe(200);
        expect(response.text).toContain('Welcome to testing');
    });
});

