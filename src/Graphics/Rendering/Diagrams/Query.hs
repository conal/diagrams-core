{-# LANGUAGE TypeFamilies
           , GeneralizedNewtypeDeriving
  #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Graphics.Rendering.Diagrams.Query
-- Copyright   :  (c) 2011 diagrams-core team (see LICENSE)
-- License     :  BSD-style (see LICENSE)
-- Maintainer  :  diagrams-discuss@googlegroups.com
--
-- The @Query@ module defines a type for \"queries\" on diagrams, which
-- are functions from points in a vector space to some monoid.
--
-----------------------------------------------------------------------------

module Graphics.Rendering.Diagrams.Query
       ( Query(..)
       ) where

import Graphics.Rendering.Diagrams.V
import Graphics.Rendering.Diagrams.Transform
import Graphics.Rendering.Diagrams.Points
import Graphics.Rendering.Diagrams.HasOrigin

import Data.VectorSpace
import Data.AffineSpace

import Data.Monoid
import Control.Applicative

------------------------------------------------------------
--  Queries  -----------------------------------------------
------------------------------------------------------------

-- | A query is a function that maps points in a vector space to
--   values in some monoid. Queries naturally form a monoid, with
--   two queries being combined pointwise.
newtype Query v m = Query { runQuery :: Point v -> m }
  deriving (Functor, Applicative, Monoid)

type instance V (Query v m) = v

instance VectorSpace v => HasOrigin (Query v m) where
  moveOriginTo (P u) (Query f) = Query $ \p -> f (p .+^ u)

instance HasLinearMap v => Transformable (Query v m) where
  transform t (Query f) = Query $ f . papply (inv t)