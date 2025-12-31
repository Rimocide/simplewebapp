export const BACKEND_URL = "";

export async function fetchPosts() {
  const response = await fetch(`${BACKEND_URL}/api/posts`);
  if (!response.ok) throw new Error("Failed to fetch posts");
  return response.json();
}

export async function createPost(title, content) {
  const response = await fetch(`${BACKEND_URL}/api/posts`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ title, content }),
  });
  if (!response.ok) throw new Error("Failed to create post");
  return response.json();
}