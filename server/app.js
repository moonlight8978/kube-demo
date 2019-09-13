const path = require("path");

const express = require("express");
const expressPino = require("express-pino-logger");

const logger = require("./logger");
const indexRouter = require("./routes/index");

const app = express();

app.use(expressPino({ logger }));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use("/", indexRouter);

module.exports = app;
