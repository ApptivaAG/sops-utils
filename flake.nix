{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system: with nixpkgs.legacyPackages.${system}; let 
    json-to-exports = writeScriptBin "json-to-exports" ''
      ${jq}/bin/jq -r 'to_entries|map("export \(.key)=\(.value|tostring|@sh);")|.[]' <&0
    '';
    test-json-to-exports = writeScriptBin "test-json-to-exports" ''
      source <(${json-to-exports}/bin/json-to-exports < test-variables.json)
      node ./check-variables.js
    '';
    sops-to-exports = writeShellScriptBin "sops-to-exports" ''
      ${sops}/bin/sops -d --output-type json $1 | ${json-to-exports}/bin/json-to-exports
    '';
  in {
    packages = {inherit json-to-exports sops-to-exports test-json-to-exports;};
  });
}
