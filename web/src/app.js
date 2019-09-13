import React, { useEffect } from "react";
import io from "socket.io-client";
import { Line } from "react-chartjs-2";

const response = {
  cpu: {
    count: 4,
    model: "Intel(R) Core(TM) i5-6400 CPU @ 2.70GHz",
    used: [1121, 1120, 1484, 1088],
    total: 2700
  },
  memory: { total: 15927.2734375, free: 1482248192 },
  time: "Fri Sep 13 2019 16:43:41 GMT+0700 (Indochina Time)"
};

const data = {
  labels: [response.time],
  datasets: [
    {
      label: "CPU",
      fill: false,
      lineTension: 0.1,
      backgroundColor: "rgba(75,192,192,0.4)",
      borderColor: "rgba(75,192,192,1)",
      borderCapStyle: "butt",
      borderDash: [],
      borderDashOffset: 0.0,
      borderJoinStyle: "miter",
      pointBorderColor: "rgba(75,192,192,1)",
      pointBackgroundColor: "#fff",
      pointBorderWidth: 1,
      pointHoverRadius: 5,
      pointHoverBackgroundColor: "rgba(75,192,192,1)",
      pointHoverBorderColor: "rgba(220,220,220,1)",
      pointHoverBorderWidth: 2,
      pointRadius: 1,
      pointHitRadius: 10,
      data: [(response.cpu.used[0] / response.cpu.total) * 100]
    }
  ]
};

function App() {
  // useEffect(() => {
  //   const stream = io.connect("http://localhost:60000/usage");
  //   stream.on("connect", () => {
  //     console.log("connected");
  //     stream.on("info", data => {
  //       console.log(data);
  //     });
  //   });

  //   return () => {
  //     stream.disconnect();
  //   };
  // }, []);

  return <Line data={data} />;
}

export default App;
