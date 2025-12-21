const express = require("express");
const cors = require("cors");
const postsRouter = require("./routes/posts");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api", postsRouter);

module.exports = app;
