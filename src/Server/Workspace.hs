-- A workspace, i.e. a directory with some `nix-shell` environment and package
-- specifications for that environment.
-- FIXME: Add capabilities for saving sessions?
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TemplateHaskell #-}
module Server.Workspace where


import Control.Exception (IOException)


import Control.Lens
import Control.Monad.Except
import Control.Monad.IO.Class
import Data.Text (Text)
import System.FilePath


import Server.API.Workspace


-- A live workspace
data Workspace = Workspace {
    _ws_name :: WorkspaceName
  , _ws_path :: FilePath
  } deriving (Show)

makeLenses ''Workspace


-- Creates the necessary directories/files for a new workspace.
initializeWorkspace ::
  ( MonadIO m
  , MonadError IOException m
  ) =>
  FilePath -> -- Base directory
  WorkspaceSpec ->
  m Workspace
initializeWorkspace = error "TODO"


deleteWorkspace ::
  ( MonadIO m
  , MonadError IOException m
  ) =>
  Workspace ->
  m ()
deleteWorkspace = error "TODO"


queryWorkspaceSpec ::
  ( MonadIO m
  , MonadError IOException m
  ) =>
  Workspace ->
  m WorkspaceSpec
queryWorkspaceSpec = error "TODO"
