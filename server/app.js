const path = require("path");

const express = require("express");
const expressPino = require("express-pino-logger");
const cors = require("cors");

const logger = require("./logger");
const indexRouter = require("./routes/index");

const app = express();

app.use(cors());
app.use(expressPino({ logger }));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use("/data", indexRouter);

module.exports = app;
