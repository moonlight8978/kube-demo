import React, { useEffect, useState } from "react";

function App() {
  const [currentTime, setCurrentTime] = useState("Dục tốc bất đạt");

  useEffect(() => {
    fetch("http://localhost:4000/data")
      .then(response => response.json())
      .then(data => setCurrentTime(data.currentTime))
      .catch(() => setCurrentTime("Server tèo"));
  }, []);

  return (
    <div>
      <span>{currentTime}</span>
    </div>
  );
}

export default App;
