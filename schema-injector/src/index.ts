import axios from "axios";
import fs from "fs";
import path from "path";

(async () => {
  await sleep(27000);

  let schema = fs.readFileSync(
    path.resolve(__dirname, "../schema.graphql"),
    "utf-8"
  );

  while (true) {
    await sleep(1000);
    try {
      const response = await axios.get<Array<any>>("http://dgraph:8080/health");
      if (response.data[0].uptime >= 30) {
        while (true) {
          const response = await axios.post(
            "http://dgraph:8080/admin/schema",
            Buffer.from(schema),
            {}
          );
          if (response.status == 200) {
            break;
          }
        }
        break;
      }
    } catch (error) {}
  }

  console.log("Successful");
})();

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}
