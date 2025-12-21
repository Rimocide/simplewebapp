export const BACKEND_URL =
  window.location.hostname === "localhost" ? "http://localhost:5000" : "";

export async function fetchPosts() {
  const response = await fetch(`${BACKEND_URL}/api/posts`);
  if (!response.ok) throw new Error("Failed to fetch posts");
  return response.json();
}
