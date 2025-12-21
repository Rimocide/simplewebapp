const { fetchPosts } = require("../services/posts.service");

async function getPosts(req, res) {
  try {
    const posts = await fetchPosts();
    res.json(posts);
  } catch (err) {
    res.status(500).json({ error: "Failed to fetch posts" });
  }
}

module.exports = { getPosts };
