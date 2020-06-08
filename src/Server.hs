-- API handlers; integration of `Server.*` with `Server.API.*`.
-- FIXME: Factor this out into:
-- - An app monad types module
-- - Individual handler modules
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE OverloadedStrings #-}
module Server where


import Control.Monad.Reader
import Control.Monad.State
import Data.Default
import Data.IORef
import Data.Map (Map)
import Data.Text (Text)
import Language.Haskell.Ghcid (Ghci)
import Servant.API


import Server.API.NixGhci
import Server.API.Workspace


import qualified Data.Map as M


--
-- Application monad; just a reader over some config, and state over stuff that
-- keeps track of request statuses.
--


newtype AppM a = AppM { runAppM :: ReaderT AppEnv IO a }
  deriving (Functor, Monad, Applicative, MonadIO, MonadReader AppEnv)

data AppEnv = AppEnv {
    _appenv_baseDir :: FilePath
  , _appenv_config :: AppConfig
  , _appenv_openGhciSessions :: IORef (Map WorkspaceName Ghci)
  }

-- XXX: This needs to be populated before the server is started, so loading
-- from file handled outside of the application monad.
data AppConfig = AppConfig {
    _appcfg_nixShellFilename :: Text
  , _appcfg_systemPackagesJSONFilename :: Text
  , _appcfg_haskellPackagesJSONFilename :: Text
  } deriving (Show)

instance Default AppConfig where
  def = AppConfig {
      _appcfg_nixShellFilename = "shell.nix"
    , _appcfg_systemPackagesJSONFilename = "systemPackages.json"
    , _appcfg_haskellPackagesJSONFilename = "haskellPackages.json"
    }

class HasBaseDir a where
  getBaseDir :: a -> FilePath

instance HasBaseDir AppEnv where
  getBaseDir = _appenv_baseDir

class HasConfig a where
  getConfig :: a -> AppConfig

instance HasConfig AppEnv where
  getConfig = _appenv_config


--
-- Handlers
--


createWorkspaceHandler ::
  ( MonadReader r m
  , HasBaseDir r
  , HasConfig r
  , MonadIO m
  ) =>
  WorkspaceSpec ->
  m NoContent
createWorkspaceHandler = error "TODO"


deleteWorkspaceHandler ::
  ( MonadReader r m
  , HasBaseDir r
  ) =>
  WorkspaceName ->
  m NoContent
deleteWorkspaceHandler = error "TODO"


queryWorkspaceHandler ::
  ( MonadReader r m
  , HasBaseDir r
  , HasConfig r
  , MonadIO m
  ) =>
  WorkspaceName ->
  m WorkspaceSpec
queryWorkspaceHandler = error "TODO"
