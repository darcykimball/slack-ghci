-- API handlers; integration of `Server.*` with `Server.API.*`.
{-# LANGUAGE OverloadedStrings #-}
module Server where


import Control.Monad.Reader
import Data.Default
import Data.Text (Text)
import Servant.API


import Server.API


--
-- Application monad; just a reader over some config, and state over stuff that
-- keeps track of request statuses.
--

newtype AppM = AppM { runAppM :: ReaderT AppEnv (StateTIO AppState IO a) }
  deriving (Functor, Monad, Applicative, MonadIO, MonadState AppState, MonadReader AppEnv)

data AppEnv = AppEnv {
    _appenv_baseDir :: FilePath
  , _appenv_configDir :: FilePath
  } deriving (Show)

data AppConfig = AppConfig {
    _appcfg_nixShellFilename :: Text
  , _appcfg_systemPackagesJSONFilename :: Text
  , _appcfg_haskellPackagesJSONFilename :: Text
  } deriving (Show)

instance Default AppConfig where
  def = AppConfig {
      _appcfg_nixShellFileName = "shell.nix"
    , _appcfg_systemPackagesJSONFilename = "systemPackages.json"
    , _appcfg_haskellPackagesJSONFilename = "haskellPackages.json"
    }

data AppState = AppState {
    _appst_pendingGhciCommands :: Map WorkspaceName Command
  } deriving (Show)
