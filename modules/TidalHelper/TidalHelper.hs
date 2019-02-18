module TidalHelper where
import Data.Maybe

lconst :: (Ord a, Num a) => a -> a -> [a]
lconst a b
    | a < b = lconstP a b []
    | a > b = lconstM a b []
    | otherwise = [a]

lconstP :: (Ord a, Num a) => a -> a -> [a] -> [a]
lconstP a b c 
    | a <= b = lconstP a (b - 1) c++[b]
    | otherwise = c

lconstM :: (Ord a, Num a) => a -> a -> [a] -> [a]
lconstM a b c 
    | a >= b = lconstM a (b + 1) c++[b]
    | otherwise = c

