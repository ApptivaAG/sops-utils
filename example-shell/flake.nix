{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.sops-utils.url = "github:ApptivaAG/sops-utils";
  inputs.sops-utils.inputs.nixpkgs.follows = "nixpkgs";
  outputs = { self, nixpkgs, flake-utils, sops-utils  }: flake-utils.lib.eachDefaultSystem (system: with nixpkgs.legacyPackages.${system}; {
    devShells.default = mkShell {
      buildInputs = [
        sops
        sops-utils.packages.${system}.sops-to-exports
      ];
    };
  });
}
