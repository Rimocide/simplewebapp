import React, { useEffect, useState } from "react";
import { fetchPosts } from "../api/posts";

export default function PostList() {
  const [posts, setPosts] = useState([]);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchPosts()
      .then(setPosts)
      .catch(err => setError(err.message));
  }, []);

  if (error) return <p style={{ color: "red", textAlign: "center" }}>{error}</p>;

  return (
    <div>
      <h1>Latest Posts</h1>
      {posts.map(post => (
        <div key={post.id} className="post">
          <h3>{post.title}</h3>
          <p>{post.body}</p>
        </div>
      ))}
    </div>
  );
}
