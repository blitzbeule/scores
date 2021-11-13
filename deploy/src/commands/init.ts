import type { Arguments, CommandBuilder } from "yargs";
import { options } from "../options";
import fs from "fs";
import path from "path";
import { startContainers } from "../util/startf";

type Options = {
  port: number | undefined;
  kport: number | undefined;
};

export const command: string = "init";
export const desc: string = "Init new scores instance";

export const builder: CommandBuilder<Options, Options> = (yargs) =>
  yargs.options({
    port: { type: "number" },
    kport: { type: "number" },
  });

export const handler = async (argv: Arguments<Options>) => {
  process.stdout.write("Loading...\n");
  let { port, kport } = argv;

  if (!port) {
    port = options.port.default;
  }
  if (!kport) {
    kport = options.kport.default;
  }
  process.stdout.write("Loaded.\n\n");

  process.stdout.write("Copying files...\n");
  let rs: Replacer[] = [
    {
      name: "port",
      value: port,
      rmS: options.port.rmS,
    },
    {
      name: "kport",
      value: kport,
      rmS: options.kport.rmS,
    },
  ];

  let kconf = fs.readFileSync(
    path.join(__dirname, "../../templates/krakend.json.template"),
    "utf-8"
  );
  let dcfile = fs.readFileSync(
    path.join(__dirname, "../../templates/docker-compose.yml.template"),
    "utf-8"
  );

  let nkconf = replaceInFile(kconf, rs, "json");
  let ndcfile = replaceInFile(dcfile, rs, "yml");

  if (!fs.existsSync(path.join(process.cwd(), "/ddata"))) {
    fs.mkdirSync(path.join(process.cwd(), "/ddata"));
  }
  if (!fs.existsSync(path.join(process.cwd(), "/krakend"))) {
    fs.mkdirSync(path.join(process.cwd(), "/krakend"));
  }

  fs.writeFileSync(path.join(process.cwd(), "/docker-compose.yml"), ndcfile);
  fs.writeFileSync(path.join(process.cwd(), "/krakend/krakend.json"), nkconf);
  fs.copyFileSync(
    path.join(__dirname, "../../templates/schema.graphql"),
    path.join(path.join(process.cwd(), "/ddata/schema.graphql"))
  );
  fs.copyFileSync(
    path.join(__dirname, "../../templates/init.sh"),
    path.join(path.join(process.cwd(), "/ddata/init.sh"))
  );
  fs.chmodSync(path.join(process.cwd(), "/ddata/init.sh"), "755");

  process.stdout.write("Files Copied.\n\n");

  process.stdout.write("Configuring...\n");

  //TODO insert better container configuration

  process.stdout.write("Successful\n");

  process.stdout.write("\n\n");

  process.stdout.write("################################################\n");
  process.stdout.write("#                                              #\n");
  process.stdout.write("# Start the application with docker-compose up #\n");
  process.stdout.write("#                                              #\n");
  process.stdout.write("################################################\n");

  process.stdout.write("\n\n");
  process.exit(0);
};

const replaceInFile = (
  file: string,
  vars: Replacer[],
  type: "yml" | "json"
): string => {
  for (let i = 0; i < vars.length; i++) {
    const rep = vars[i];
    var res;
    if (type == "yml") {
      res = `%%${rep.name}%%`;
    } else if (rep.rmS) {
      res = `"%%${rep.name}%%"`;
    } else {
      res = `%%${rep.name}%%`;
    }
    const regex = new RegExp(res, "gi");
    file = file.replace(regex, rep.value);
  }
  return file;
};

type Replacer = {
  name: string;
  value: any;
  rmS?: boolean;
};
