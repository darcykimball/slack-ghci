{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TypeOperators #-}
module Server.API.NixGhci where


import GHC.Generics


import Data.Aeson
import Data.Text (Text)
import Language.Haskell.Ghcid
import Numeric.Natural
import Servant.API
import Servant.Checked.Exceptions


--
-- Starting and stopping a ghci session.
--


type SessionID = Natural
type RelativeURI = SessionID

-- FIXME: This needs to return the URI for the new session, which is just
-- described below in the commands API.
type StartAPI =
  "start"
    :> Throws SessionAlreadyExists
    :> Throws MaxSessionLimitReached
    :> PostCreated '[Header "Location" RelativeURI] StartSuccess

data SessionAlreadyExists = SessionAlreadyExists
  deriving (Generic)
instance ToJSON SessionAlreadyExists

data MaxSessionLimitReached = MaxSessionLimitReached Natural
  deriving (Generic)
instance ToJSON MaxSessionLimitReached

data StartSuccess = StartSuccess {
    _sessionID :: SessionID
  -- TODO: Decide whether or not it's worth sending back an anonymized version
  -- of post-load messages, since they'd leak details about the filesystem.
  --, _loadMessages :: [Load]
  , _modulesLoaded :: [Text]
  } deriving (Generic)
instance ToJSON StartSuccess


type StopAPI =
  "stop"
    :> Throws StopError
    :> Delete '[JSON] StopSuccess

data StopError =
    NonexistentSession
  | InternalErrorWhileStopping
  deriving (Generic)
instance ToJSON StopError

data StopSuccess = StopSuccess
  deriving (Generic)
instance ToJSON StopSuccess


--
-- Issuing ghci commands
--


type CommandAPI =
  "command"
    :> Capture "commandText" Text
    :> Throws CommandError
    :> Throws CommandTimedOut
    :> Patch '[JSON] CommandSuccess

-- TODO: Should put a server-local timestamp on these, in case things happen out
-- of order?
data CommandError = CommandError Text
  deriving (Show, Generic)
instance ToJSON CommandError

data CommandTimedOut = CommandTimedOut
  deriving (Show, Generic)
instance ToJSON CommandTimedOut


data CommandSuccess = CommandSuccess Text
  deriving (Generic)
instance ToJSON CommandSuccess
