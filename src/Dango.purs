module Dango
  ( SizedList
  , toList
  , toNonEmptyList
  , empty
  , singleton
  , head
  , tail
  , append
  ) where

import Prelude

import Data.List (List)
import Data.List as List
import Data.List.NonEmpty as NEL
import Data.List.Types (NonEmptyList)
import Data.Maybe (fromJust)
import Partial.Unsafe (unsafePartial)
import Prim.Symbol as Symbol

-- | a sized list using a symbol of "." to mark length at the type level.
newtype SizedList (size :: Symbol) a = SizedList (List a)
derive newtype instance showSizedList :: Show a => Show (SizedList s a)
derive newtype instance eqSizedList :: Eq a => Eq (SizedList s a)
derive newtype instance ordSizedList :: Ord a => Ord (SizedList s a)
derive newtype instance functorSizedList :: Functor (SizedList s)
derive newtype instance applySizedList :: Apply (SizedList ".")
derive newtype instance applicativeSizedList :: Applicative (SizedList ".")

toList :: forall s a. SizedList s a -> List a
toList (SizedList xs) = xs

-- | get a NonEmptyList from a list, as guaranteed by the length symbol
toNonEmptyList
  :: forall s tail a
   . Symbol.Cons "." tail s
  => SizedList s a
  -> NonEmptyList a
toNonEmptyList (SizedList xs) = unsafePartial $ fromJust $ NEL.fromFoldable xs

empty :: forall a. SizedList "" a
empty = SizedList List.Nil

singleton :: forall a. a -> SizedList "." a
singleton x = SizedList (List.singleton x)

-- | get the head of a list that has an item in it, as guaranteed by the length symbol
head
  :: forall a tail s
   . Symbol.Cons "." tail s
  => SizedList s a
  -> a
head (SizedList xs) = unsafePartial $ fromJust $ List.head xs

-- | get the tail of a list, with the length symbol deconstructed
tail
  :: forall a s tail
   . Symbol.Cons "." tail s
  => SizedList s a
  -> SizedList tail a
tail (SizedList xs) =
  unsafePartial $ case xs of
    List.Cons _ ys -> SizedList ys

-- | append two lists, with the length symbol appended
append
  :: forall l r s a
   . Symbol.Append l r s
  => SizedList l a
  -> SizedList r a
  -> SizedList s a
append (SizedList xs) (SizedList ys) = SizedList (xs <> ys)
