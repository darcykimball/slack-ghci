-- Ad-hoc script-like functions for:
-- - Creating nix-related files
-- - Creating `nix-shell` environments
-- - Starting a `ghci` session within a `nix-shell`
{-# LANGUAGE OverloadedStrings #-}
module Server.NixGhci (

  ) where 


import System.Process


import Control.Lens
import Data.Text (Text)
import Language.Haskell.Ghcid


import Server.Workspace


import qualified Data.Text as T


-- The state of a single ghci session running inside some `nix-shell`.
data SessionEnv = SessionEnv {
    _seshEnv_haskellPackages :: [Text]
  , _seshEnv_systemPackages :: [Text]
  , _seshEnv_workspace :: Workspace
  }


-- Start a ghci session within `nix-shell`.
startNixGhci :: SessionEnv -> (Stream -> String -> IO ()) -> IO (Ghci, [Load])
startNixGhci (SessionEnv haskellPkgs systemPkgs workspace) =
  startGhci nixShellCmd (Just $ workspace ^. ws_path)
  where
    nixShellCmd = unwords [
        "nix-shell"
      , "shell.nix"
      , "--pure" -- XXX: Probably unnecessary for our purposes, but why not.
      , "--arg", "haskellPackageNames", nixListify haskellPkgs
      , "--arg", "systemPackageNames", nixListify systemPkgs
      , "--command", "ghci"
      ]

    nixListify xs = "[" <> (T.unpack. T.unwords $ xs) <> "]"
