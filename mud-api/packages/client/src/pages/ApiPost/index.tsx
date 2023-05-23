import { useState, useEffect } from "react";
import env from "../../env";

export function ApiPost() {
  const [endpoint, setEndpoint] = useState<string>(
    "http://localhost:3000/attribute"
  );
  const [body, setBody] = useState<string>(
    '{"player": "GarrickStormwind", "attribute": "strength", "value": 100}'
  );
  const [result, setResult] = useState<string>("");
  const [getValue, setGetValue] = useState<string>(
    "http://localhost:3000/attribute/strength/GarrickStormwind"
  );
  const [attributeValue, setAttributeValue] = useState<string>("");

  const postToApi = async () => {
    setResult("Posting...");

    try {
      const res = await fetch(endpoint, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: body,
      });

      if (!res.ok) {
        throw new Error("An error occurred in the HTTP request");
      }

      setResult("POST request successful!");
    } catch (error) {
      console.error(error);
      setResult("Error: " + error.message);
    }
  };

  const fetchAttributeValue = async () => {
    try {
      const res = await fetch(getValue);

      if (!res.ok) {
        throw new Error("An error occurred in the HTTP request");
      }

      const data = await res.json();
      setAttributeValue(data.value);
    } catch (error) {
      console.error(error);
      setAttributeValue("Error: " + error.message);
    }
  };

  useEffect(() => {
    fetchAttributeValue();
  }, [getValue]);

  return (
    <div className="p-4 border rounded-md bg-gray-100">
      <h2 className="text-xl font-semibold mb-4">MUD API Post</h2>
      <div className="flex flex-col gap-4 mb-4">
        <div>
          <label htmlFor="endpoint" className="mr-2">
            Endpoint URL:
          </label>
          <input
            type="text"
            id="endpoint"
            value={endpoint}
            onChange={(e) => setEndpoint(e.target.value)}
            className="border border-gray-300 rounded px-2 py-1 w-[300px]"
          />
        </div>
        <div>
          <label htmlFor="json" className="mr-2">
            JSON Payload:
          </label>
          <textarea
            id="json"
            value={body}
            onChange={(e) => setBody(e.target.value)}
            className="border border-gray-300 rounded px-2 py-1 w-[300px]"
            rows={4}
          />
        </div>
      </div>
      <div>
        <button
          onClick={postToApi}
          className="bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded"
        >
          Post to API!
        </button>
      </div>
      {result && (
        <div className="mt-4">
          <strong>Result:</strong> {result}
        </div>
      )}
      <div className="mt-8">
        <h3 className="text-lg font-semibold">Get Attribute Value</h3>
        <div className="flex flex-col gap-4 mb-4">
          <div>
            <label htmlFor="getValue" className="mr-2">
              Endpoint URL:
            </label>
            <input
              type="text"
              id="getValue"
              value={getValue}
              onChange={(e) => setGetValue(e.target.value)}
              className="border border-gray-300 rounded px-2 py-1 w-[500px]"
            />
          </div>
        </div>
        <button
          onClick={fetchAttributeValue}
          className="bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded"
        >
          Get Attribute Value
        </button>
        {attributeValue && (
          <div className="mt-4">
            <strong>Attribute Value:</strong> {attributeValue}
          </div>
        )}
      </div>
    </div>
  );
}
