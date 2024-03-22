import React, { useState, useEffect } from "react";

function EnvContent() {
  const [envContent, setEnvContent] = useState("");

  useEffect(() => {
    fetch("/api/env")
      .then((response) => response.json())
      .then((data) => setEnvContent(data.envContent))
      .catch((error) =>
        console.error("Error fetching environment content:", error)
      );
  }, []);

  return (
    <div>
      <h2>Environment Content</h2>
      <pre>{envContent}</pre>
    </div>
  );
}

export default EnvContent;
