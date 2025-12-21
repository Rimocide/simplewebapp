beforeEach(() => {
  document.body.innerHTML = `<div id="posts"></div>`;

  const mockFetch = jest.fn(() =>
    Promise.resolve({
      json: () =>
        Promise.resolve([{ title: "Test", body: "Test body" }])
    })
  );

  global.fetch = mockFetch;
  window.fetch = mockFetch;

  jest.resetModules();
});

test("renders posts", async () => {
  const { loadPosts } = require("../src/app");

  await loadPosts();

  const posts = document.querySelectorAll(".post");
  expect(posts.length).toBe(1);
});
