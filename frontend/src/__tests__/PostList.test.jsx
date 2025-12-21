import { render, screen, waitFor } from "@testing-library/react";
import PostList from "../components/PostList";
import * as api from "../api/posts";
import '@testing-library/jest-dom';


jest.mock("../api/posts");

test("renders posts from backend", async () => {
  api.fetchPosts.mockResolvedValue([{ id: 1, title: "Test Post", body: "Test body" }]);

  render(<PostList />);

  await waitFor(() => screen.getByText("Test Post"));

  expect(screen.getByText("Test Post")).toBeInTheDocument();
  expect(screen.getByText("Test body")).toBeInTheDocument();
});
