{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
-- API for creating and manipulating separate workspaces, i.e. package
-- environments possibly coupled with some persistent state.
module Server.API.Workspace where


import System.FilePath


import Data.Text (Text)
import Network.HTTP.Types.Status
import Servant.API
import Servant.Checked.Exceptions


type WorkspaceAPI =
  "workspaces"
    :> (
           CreateAPI
      :<|> DeleteAPI
      :<|> QueryAPI
    )

type CreateAPI =
  "create"
    :> ReqBody '[JSON] WorkspaceSpec
    :> Throws WorkspaceAlreadyExists
    :> PostCreated '[Header "Location" RelativeURI] NoContent

data WorkspaceAlreadyExists = WorkspaceAlreadyExists

type RelativeURI = Text


type DeleteAPI =
  "delete"
    :> Capture "name" WorkspaceName
    :> Throws NonexistentWorkspace
    :> Delete '[] NoContent

data NonexistentWorkspace = NonexistentWorkspace
  deriving (Show)

instance ErrStatus NonexistentWorkspace where
  toErrStatus _ = status404 -- TODO: This value is debatable?


type QueryAPI =
  "query"
    :> Capture "name" WorkspaceName
    :> Throws NonexistentWorkspace
    :> Get '[JSON] WorkspaceSpec
  

-- This is the resource identifier both given by client and returned back when
-- successfully created.
type WorkspaceName = Text

data WorkspaceSpec = WorkspaceSpec {
    _ws_name :: WorkspaceName
  , _ws_haskellPackages :: [Text]
  , _ws_systemPackages :: [Text]
  } deriving (Show, Eq)
