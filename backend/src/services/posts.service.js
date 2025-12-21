const axios = require("axios");

async function fetchPosts() {
  const response = await axios.get(
    "https://jsonplaceholder.typicode.com/posts?_limit=5"
  );
  return response.data;
}

module.exports = { fetchPosts };
