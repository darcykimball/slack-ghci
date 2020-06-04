# A general template for a haskell environment.
# This is used by `Server.NixGhci` to provision requested environments.
{
    nixpkgsVersionJSON ? ./nixpkgs-version.json
  , haskellPackagesNames
  , systemPackageNames
}:
let
  pkgs =
    let
      hostPkgs = import <nixpkgs> {};
      pinnedVersion = hostPkgs.lib.importJSON ./nixpkgs-version.json;
      pinnedPkgs = hostPkgs.fetchFromGitHub  {
        owner = "NixOS";
        repo = "nixpkgs-channels";
        inherit (pinnedVersion) rev sha256;
      };
    in import pinnedPkgs {};

    haskellDeps = ps: with ps; haskellPackageNames;

    ghc = haskellPackages.ghcWithPackages haskellDeps;

    nixPackages = [ghc] ++ systemPackageNames;
in
  pkgs.stdenv.mkDerivation {
    name = "env";
    buildInputs = nixPackages;
  }
