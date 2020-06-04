-- A workspace, i.e. a directory with some `nix-shell` environment and package
-- specifications for that environment.
-- FIXME: Add capabilities for saving sessions?
module Server.Workspace where


import Data.Text (Text)


data Workspace = Workspace {
    _ws_name :: Text
  , _ws_path :: FilePath
  }
