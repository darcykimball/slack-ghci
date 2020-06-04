{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
-- API for creating and manipulating separate workspaces, i.e. package
-- environments possibly coupled with some persistent state.
module Server.API.Workspace where


import Data.FilePath


import Data.Text (Text)
import Servant.API


-- FIXME: There should be a type-level map on alternated sub-apis? Use it.
type WorkspaceAPI =
  "workspaces"
    :> (
           CreateAPI
      :<|> DeleteAPI
      :<|> QueryAPI
    )

type CreateAPI =
  "create"
    :> ReqBody '[JSON] WorkspaceEnv
    :> PostCreated '[Header "Location" RelativeURI] NoContent

type RelativeURI = Text


type DeleteAPI =
  "delete"
    :> Capture "name" WorkspaceName
    :> Delete '[] ()


type QueryAPI =
    :> Capture "name" WorkspaceName
    :> Get '[JSON] WorkspaceEnv
  

-- This is the resource identifier both given by client and returned back when
-- successfully created.
type WorkspaceName = Text

data WorkspaceEnv = WorkspaceEnv {
    _ws_name :: WorkspaceName
    -- The haskell package set available in this workspace.
    -- Invariant: always sorted
  , _ws_packageSet :: [Text] 
  } deriving (Show, Eq)
