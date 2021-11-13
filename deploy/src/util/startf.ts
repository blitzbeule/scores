import { spawn } from "child_process";

export async function startContainers(options?: {
  nd?: boolean;
  noStart?: boolean;
}): Promise<number> {
  let resolves: (value: number | PromiseLike<number>) => void;
  let rejects: (reason?: any) => void;
  let args: string[] = ["up"];

  if (options != undefined) {
    if (!options.nd) {
      args.push("--detach");
    }
    if (options.noStart) {
      args.push("--no-start");
    }
  } else {
    args.push("--detach");
  }

  console.dir(args);

  const dc = spawn("docker-compose", args);

  dc.stdout.on("data", (data) => {
    process.stdout.write(`docker-compose: ${data}`);
  });

  dc.stderr.on("data", (data) => {
    process.stderr.write(`docker-compose: ${data}`);
  });

  const promise = new Promise<number>((resolve, reject) => {
    resolves = resolve;
    rejects = reject;
  });

  dc.on("close", (code) => {
    if (code == null) {
      rejects("code is not defined");
    } else {
      resolves(code as number);
    }
  });

  return promise;
}

/*export async function configureContainers() {
  let resolves: (value: number | PromiseLike<number>) => void;
  let rejects: (reason?: any) => void;
  let args: string[] = [
    "run",
    "--service-ports",
    "--rm",
    "alpha",
    "sh",
    "-c",
    "./init.sh",
  ];

  const dc = spawn("docker-compose", args);

  dc.stdout.on("data", (data) => {
    process.stdout.write(`configure: ${data}`);
  });

  dc.stderr.on("data", (data) => {
    process.stderr.write(`configure: ${data}`);
  });

  const promise = new Promise<number>((resolve, reject) => {
    resolves = resolve;
    rejects = reject;
  });

  dc.on("close", (code) => {
    if (code == null) {
      rejects("code is not defined");
    } else {
      resolves(code as number);
    }
  });

  return promise;
}
*/
