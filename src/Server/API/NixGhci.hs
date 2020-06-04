{-# LANGUAGE DataKinds -#}
{-# LANGUAGE DeriveGeneric -#}
{-# LANGUAGE TypeOperators #-}
module Server.API.NixGhci where


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
    :> Throws StartError
    :> PostCreated '[Header "Location" RelativeURI] StartSuccess

data StartError =
    SessionAlreadyExists
  | MaxSessionLimitReached Natural
  deriving (Generic)
instance ToJSON StartError

data StartSuccess = StartSuccess {
    _sessionID :: SessionID
  , _loadMessages :: [Load]
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
    :> Patch '[JSON] CommandSuccess

-- TODO: If possible, make this a sum type over things like type errors, syntax
-- errors, etc., which'll make it easier on the client-side to decide how to
-- process output. For now, it's just whatever ghci spits out.
data CommandError = CommandError Text
  deriving (Generic)
instance ToJSON CommandError

data CommandSuccess = CommandSuccess Text
  deriving (Generic)
instance ToJSON CommandSuccess
