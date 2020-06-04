-- State monad transformer for monad stacks with `IO` at the base.
-- FIXME: This has to be implemented somewhere on hackage.
module Control.Monad.Trans.StateIO (
    StateIOT
  , StateIO
  , runStateIOT
  ) where


import Data.IORef


import Control.Monad.Trans
import Control.Monad.IO.Class
import Control.Monad.State.Class


newtype StateIOT s m a = StateIOT { unStateIOT :: IORef s -> m a }


type StateIO s = StateIOT IO s


instance Functor m => Functor (StateIOT s m) where
  fmap f x = StateIOT $ \_ -> fmap f $ unStateIOT x

instance Applicative m => Applicative (StateIOT s m) where
  pure a = StateIOT $ \_ -> return a
  f <*> a = StateIOT $ \_ -> unStateIOT f <*> unStateIOT a

instance Monad m => Monad (StateIOT s m) where
  x >>= f = StateIOT $ \sref -> unStateIOT x sref >>= unStateIOT . f

instance MonadTrans (StateIOT s) where
  lift x = StateIOT $ \_ -> x

instance MonadIO m => MonadIO (StateIOT s m) where
  liftIO x = StateIOT $ \_ -> liftIO x

instance MonadIO m => MonadState s (StateIOT s m) where
  get = StateIOT $ \sref -> liftIO $ readIORef sref
  put s = StateIOT $ \sref -> liftIO $ writeIORef sref s


runStateIOT :: MonadIO m => StateIOT s m a -> s -> m (s, a)
runStateIOT x = do
  sref <- newIORef s
  a <- unStateIOT x sref
  s' <- readIORef sref
  return (s', a)
