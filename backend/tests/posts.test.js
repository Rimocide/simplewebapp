const request = require("supertest");
const app = require("../src/app");

describe("GET /api/posts", () => {
  it("returns a list of posts", async () => {
    const res = await request(app).get("/api/posts");

    expect(res.statusCode).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
    expect(res.body.length).toBeGreaterThan(0);
    expect(res.body[0]).toHaveProperty("title");
  });
});
