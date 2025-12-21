const express = require("express");
const router = express.Router();

const posts = [
  { id: 1, title: "Backend Post", body: "Served from backend API" }
];

router.get("/posts", (req, res) => {
  res.json(posts);
});

module.exports = router;
