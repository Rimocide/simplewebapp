const express = require("express");
const router = express.Router();
const db = require("../db");

// Get all posts
router.get("/posts", async (req, res) => {
  try {
    const [rows] = await db.query("SELECT * FROM posts ORDER BY created_at DESC");
    res.json(rows);
  } catch (err) {
    console.error("Error fetching posts:", err);
    res.status(500).json({ error: "Failed to fetch posts" });
  }
});

// Create a new post
router.post("/posts", async (req, res) => {
  try {
    const { title, content } = req.body;
    if (!title || !content) {
      return res.status(400).json({ error: "Title and content are required" });
    }
    const [result] = await db.query(
      "INSERT INTO posts (title, content) VALUES (?, ?)",
      [title, content]
    );
    res.status(201).json({ id: result.insertId, title, content });
  } catch (err) {
    console.error("Error creating post:", err);
    res.status(500).json({ error: "Failed to create post" });
  }
});

module.exports = router;

