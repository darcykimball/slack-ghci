{ mkDerivation, aeson, base, ghcid, lens, servant
, servant-checked-exceptions, stdenv, text
}:
mkDerivation {
  pname = "slack-ghci";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base ghcid lens servant servant-checked-exceptions text
  ];
  executableHaskellDepends = [
    aeson base ghcid lens servant servant-checked-exceptions text
  ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
