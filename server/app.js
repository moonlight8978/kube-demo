const path = require("path");

const express = require("express");
const expressPino = require("express-pino-logger");
const cors = require("cors");

const logger = require("./logger");

const app = express();

app.use(cors());
app.use(expressPino({ logger }));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.get("/data", (req, res) =>
  res.status(200).json({ currentTime: new Date() })
);
app.get("/healthcheck", (req, res) =>
  res.status(200).json({ message: "Healthy" })
);

module.exports = app;
