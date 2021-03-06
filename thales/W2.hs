module W2 where

-- Week 2:
--
--  * lists
--  * strings
--  * library functions for them
--  * higher order functions
--  * polymorphism
--
-- Functions you will need:
--  * head, tail
--  * take, drop
--  * length
--  * null
--  * map
--  * filter
--
-- You can ask ghci for the types of these functions with the :t
-- command:
--
--  Prelude> :t length
--  length :: [a] -> Int

import Data.List
import Data.Char

-- Ex 1: Define the constant years, that is a list of the values 1982,
-- 2004 and 2012 in this order.

years = [1982, 2004, 2012]

-- Ex 2: define the function measure that for an empty list returns -1
-- and for other lists returns the length of the list.

measure :: [String] -> Int
measure [] = -1
measure ss = length ss

-- Ex 3: define the function takeFinal, which returns the n last
-- elements of the given list.

takeFinal :: Int -> [Int] -> [Int]
takeFinal _ [] = []
takeFinal 0 _  = []
takeFinal n xs = let l = length xs
                 in drop (l - n) xs

-- Ex 4: remove the nth element of the given list. More precisely,
-- return a list that is identical to the given list except the nth
-- element is missing.
--
-- Note! indexing starts from 0
--
-- Examples:
-- remove 0 [1,2,3]    ==>  [2,3]
-- remove 2 [4,5,6,7]  ==>  [4,5,7]
--
-- The [a] in the type signature means "a list of any type"

remove :: Int -> [a] -> [a]
remove i xs = take i xs ++ drop (i + 1) xs

-- Ex 5: substring i n s should return the length n substring of s
-- starting at index i.
--
-- Remember that strings are lists!

substring :: Int -> Int -> String -> String
substring i n = take n . drop i

-- Ex 6: implement the function mymax that takes as argument a
-- measuring function (of type a -> Int) and two values (of type a).
--
-- mymax should apply the measuring function to both arguments and
-- return the argument for which the measuring function returns a
-- higher value.
--
-- Examples:
--
--  mymax (*2)   3       5      ==>  5
--  mymax length [1,2,3] [4,5]  ==>  [1,2,3]
--  mymax head   [1,2,3] [4,5]  ==>  [4,5]

mymax :: (a -> Int) -> a -> a -> a
mymax measure a b =
  case compare (measure a) (measure b) of
    EQ -> a
    LT -> b
    GT -> a

-- Ex 7: countSorted receives a list of strings and returns a count of
-- how many of the strings are in alphabetical order (i.e. how many of
-- the strings have their letters in alphabetical order)
--
-- Remember the functions length, filter and sort

countSorted :: [String] -> Int
countSorted ss = length
               . filter (\s -> s == sort s)
               $ ss

-- Ex 8: Implement a function funny, that
--  - takes in a list of strings
--  - returns a string
--    - that contains all input words of length over 5
--    - ... combined into one string
--    - ... separated with spaces
--    - ... and converted to upper case!
--
-- These functions will help:
--  - toUpper :: Char -> Char   from the module Data.Char
--  - intercalate               from the module Data.List

funny :: [String] -> String
funny strings =
  let
    strings' = filter (\s -> length s > 5) strings
  in
    map toUpper $ intercalate " " strings'

-- Ex 9: implement quicksort. Quicksort is a recursive sorting
-- algorithm that works like this.
--
--  - The empty list is the base case of the recursion: it is already sorted
--  - From a nonempty list, the first element is chosen to be the "pivot", and
--    - the elements smaller than pivot are gathered into a list
--    - the elements smaller than larger or equal to the pivot are gathered
--    - these two lists are sorted using recursion
--    - finally the small elements, the pivot and the large elements
--      are combined into one sorted list
--
-- PS. yes if you want to nit-pick this isn't really quicksort :)

quicksort :: [Int] -> [Int]
quicksort [] = []
quicksort [x] = [x]
quicksort (x:xs) =
  quicksort (filter (<= x) xs) ++ [x] ++ quicksort (filter (> x) xs)

-- Ex 10: powers k max should return all the powers of k that are less
-- than or equal to max. For example:
--
-- powers 2 5 ==> [1,2,4]
-- powers 3 30 ==> [1,3,9,27]
-- powers 2 2 ==> [1,2]
--
-- Hints:
--   * n^max > max
--   * the function takeWhile

powers :: Int -> Int -> [Int]
powers n mx = go 0
  where
    go m | n ^ m > mx = []
    go m = n ^ m : go (m + 1)

-- Ex 11: implement a search function that takes an updating function,
-- a checking function and an initial value. Search should repeatedly
-- apply the updating function to the initial value until a value is
-- produced that passes the checking function. This value is then
-- returned.
--
-- Examples:
--
--   search (+1) even 0   ==>   0
--
--   search (+1) (>4) 0   ==>   5
--
--   let check [] = True
--       check ('A':xs) = True
--       check _ = False
--   in search tail check "xyzAvvt"
--     ==> Avvt

search :: (a -> a) -> (a -> Bool) -> a -> a
search update check initial =
  if check initial
    then initial
    else search update check (update initial)

-- Ex 12: given numbers n and k, build the list of numbers n,n+1..k.
-- Use recursion and the : operator to build the list.

fromTo :: Int -> Int -> [Int]
fromTo n k =
  case compare n k of
    LT -> n : fromTo (n + 1) k
    EQ -> [n]
    GT -> []

-- Ex 13: given i, build the list of sums [1, 1+2, 1+2+3, .., 1+2+..+i]
--
-- Ps. you'll probably need a recursive helper function

sums :: Int -> [Int]
sums i = go 1 0
  where
    go j _ | j > i = []
    go j acc = j + acc : go (j + 1) (acc + j)

-- Ex 14: using list pattern matching and recursion, define a function
-- mylast that returns the last value of the given list. For an empty
-- list, a provided default value is returned.
--
-- Examples:
--   mylast 0 [] ==> 0
--   mylast 0 [1,2,3] ==> 3

mylast :: a -> [a] -> a
mylast def [] = def
mylast _ [x] = x
mylast def (x:xs) = mylast def xs

-- Ex 15: define a function that checks if the given list is in
-- increasing order. Use recursion and pattern matching. Don't use any
-- library list functions.

sorted :: [Int] -> Bool
sorted [] = True
sorted [_] = True
sorted (x:y:rest) = if x <= y then sorted (y:rest) else False

-- Ex 16: compute the partial sums of the given list like this:
--
--   sumsOf [a,b,c]  ==>  [a,a+b,a+b+c]
--   sumsOf [a,b]    ==>  [a,a+b]
--   sumsOf []       ==>  []

sumsOf :: [Int] -> [Int]
sumsOf [] = []
sumsOf (x:xs) = x : go x xs
  where
    go _ [] = []
    go x (y:ys) = x + y : go (x + y) ys

-- Ex 17: define the function mymaximum that takes a list and a
-- comparing function of type a -> a -> Ordering and returns the
-- maximum value of the list, according to the comparing function.
--
-- For an empty list the given default value is returned.
--
-- Examples:
--   mymaximum compare (-1) [] ==> -1
--   mymaximum compare (-1) [1,3,2] ==> 3
--   let comp 0 0 = EQ
--       comp _ 0 = LT
--       comp 0 _ = GT
--       comp x y = compare x y
--   in mymaximum comp 1 [1,4,6,100,0,3]
--     ==> 0

mymaximum :: (a -> a -> Ordering) -> a -> [a] -> a
mymaximum _ def [] = def
mymaximum cmp _ (x:xs) = go x xs
  where
    go acc [] = acc
    go acc (y:ys) =
      case cmp y acc of
        GT -> go y ys
        _  -> go acc ys

-- Ex 18: define a version of map that takes a two-argument function
-- and two lists. Example:
--   map2 f [x,y,z,w] [a,b,c]  ==> [f x a, f y b, f z c]
--
-- Use recursion and pattern matching.
--
-- Ps. this function is in the Haskell Prelude but under a different
-- name.

map2 :: (a -> b -> c) -> [a] -> [b] -> [c]
map2 _ [] _ = []
map2 _ _ [] = []
map2 f (x:xs) (y:ys) = f x y : map2 f xs ys

-- Ex 19: in this exercise you get to implement an interpreter for a
-- simple language. The language controls two counters, A and B, and
-- has the following commands:
--
-- incA -- increment counter A by one
-- incB -- likewise for B
-- decA -- decrement counter A by one
-- decB -- likewise for B
-- printA -- print value in counter A
-- printB -- print value in counter B
--
-- The interpreter will be a function of type [String] -> [String].
-- Its input is a list of commands, and its output is a list of the
-- results of the print commands in the input.
--
-- Both counters should start at 0.
--
-- Examples:
--
-- interpreter ["incA","incA","incA","printA","decA","printA"] ==> ["3","2"]
-- interpreter ["incA","incB","incB","printA","printB"] ==> ["1","2"]
--
-- Surprise! after you've implemented the function, try running this in GHCi:
--     interact (unlines . interpreter . lines)
-- after this you can enter commands on separate lines and see the
-- responses to them
--
-- Unfortunately the surprise might not work if you've implemented
-- your interpreter correctly but weirdly :(

interpreter :: [String] -> [String]
interpreter commands = reverse $ fst $ foldl interpret ([], (0, 0)) commands
  where
    interpret :: ([String], (Int, Int)) -> String -> ([String], (Int, Int))
    interpret (out, (a, b)) "incA" = (out, (a + 1, b))
    interpret (out, (a, b)) "incB" = (out, (a, b + 1))
    interpret (out, (a, b)) "decA" = (out, (a - 1, b))
    interpret (out, (a, b)) "decB" = (out, (a, b - 1))
    interpret (out, (a, b)) "printA" = ((show a : out), (a, b))
    interpret (out, (a, b)) "printB" = ((show b : out), (a, b))
    interpret acc _ = acc

-- Ex 20: write a function that finds the n first squares (numbers of
-- the form x*x) that start and end with the same digit.
--
-- Example: squares 9 ==> [1,4,9,121,484,676,1521,1681,4624]
--
-- Remember, the function show transforms a number to a string.

squares :: Int -> [Integer]
squares n = take n $ [n2
                     | m <- [1..]
                     , let n2 = m*m
                     , let showN2 = show n2
                     , head showN2 == last showN2
                     ]
