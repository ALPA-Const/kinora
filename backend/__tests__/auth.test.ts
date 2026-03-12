import request from 'supertest';

import app from '../src/index';

describe('Auth — validate-code endpoint', () => {
  it('rejects missing code with 400', async () => {
    const res = await request(app).post('/api/v1/auth/validate-code').send({});
    expect(res.status).toBe(400);
  });

  it('rejects malformed code with 400', async () => {
    const res = await request(app)
      .post('/api/v1/auth/validate-code')
      .send({ code: 'NOT-A-VALID-CODE' });
    expect(res.status).toBe(400);
  });

  it('returns 404 for a well-formed but unknown code', async () => {
    const res = await request(app)
      .post('/api/v1/auth/validate-code')
      .send({ code: 'KINORA-TEST-2024-ABCD' });
    expect(res.status).toBe(404);
    expect(res.body.error).toHaveProperty('code', 'CODE_NOT_FOUND');
  });
});

describe('Auth — register endpoint', () => {
  it('rejects registration with weak password', async () => {
    const res = await request(app).post('/api/v1/auth/register').send({
      code: 'KINORA-TEST-2024-ABCD',
      email: 'test@example.com',
      password: 'weak',
      displayName: 'Test User',
    });
    expect(res.status).toBe(400);
  });

  it('rejects registration with invalid email', async () => {
    const res = await request(app).post('/api/v1/auth/register').send({
      code: 'KINORA-TEST-2024-ABCD',
      email: 'not-an-email',
      password: 'StrongPass1',
      displayName: 'Test User',
    });
    expect(res.status).toBe(400);
  });
});
