const socket = require("socket.io");

const logger = require("./logger");
const { getResourceUsage } = require("./business");

module.exports = {
  init: server => {
    const io = socket(server);

    io.of("/usage").on("connection", socket => {
      logger.debug("connected");
      setInterval(() => {
        socket.emit("info", getResourceUsage());
      }, 1000);

      socket.on("disconnect", () => {
        logger.debug("disconnected");
      });
    });
  }
};
