import esbuild from "esbuild";
import fs from "fs";
import path from 'path';

/** @type {import('esbuild').BuildOptions} */
const server = {
  platform: "node",
  target: ["node16"],
  format: "cjs",
};

/** @type {import('esbuild').BuildOptions} */
const client = {
  platform: "browser",
  target: ["es2021"],
  format: "iife",
};

const production = process.argv.includes("--mode=production");
const buildCmd = production ? esbuild.build : esbuild.context;

fs.writeFileSync(
  ".yarn.installed",
  new Date().toLocaleString("en-AU", {
    timeZone: "UTC",
    timeStyle: "long",
    dateStyle: "full",
  })
);

for (const context of ["client", "server"]) {
  const contextPath = path.resolve(context);
  let files = fs.readdirSync(contextPath);
  files = files.filter((file) => file.endsWith(".ts"));

  for (const file of files) {
    let fileWithoutExtension = file.split(".")[0];
    buildCmd({
      bundle: true,
      entryPoints: [`${context}/${fileWithoutExtension}.ts`],
      outfile: `../build/${context}/${fileWithoutExtension}.js`,
      keepNames: false,
      dropLabels: production ? ["DEV"] : undefined,
      legalComments: "inline",
      plugins: production
        ? undefined
        : [
            {
              name: "rebuild",
              setup(build) {
                const cb = (result) => {
                  if (!result || result.errors.length === 0)
                    console.log(`Successfully built ${context}/${file}`);
                };
                build.onEnd(cb);
              },
            },
          ],
      ...(context === "client" ? client : server),
    })
      .then((build) => {
        if (production) return console.log(`Successfully built ${context}/${file}`);
        build.watch();
      })
      .catch(() => process.exit(1));
  }
}
