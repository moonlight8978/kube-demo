const os = require("os");

function getCpuSpeed() {
  return parseFloat(os.cpus()[0].model.match(/(\d+\.\d+)(?:GHz)/)[1]);
}

const totalCpuSpeed = getCpuSpeed() * 1000;

function getResourceUsage() {
  const cpus = os.cpus();

  return {
    cpu: {
      count: cpus.length,
      model: cpus[0].model,
      used: cpus.map(cpu => cpu.speed),
      total: totalCpuSpeed
    },
    memory: {
      total: os.totalmem() / (1024 * 1024),
      free: os.freemem()
    }
  };
}

module.exports = {
  getResourceUsage
};
