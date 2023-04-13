const variables = JSON.parse(
  require("fs").readFileSync("./test-variables.json") + ""
);

for (const variable in variables) {
  console.log(`checking variable ${variable}`);
  if (variables[variable] !== process.env[variable])
    throw new Error(`variable ${variable} does not match!`);
}
console.log("all variables match");
