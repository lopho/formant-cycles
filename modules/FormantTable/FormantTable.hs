module FormantTable where
import Data.List

data Voice = Bass | Tenor | CounterTenor | Alto | Soprano deriving (Eq, Show)
data Vowel = A | E | I | O | U deriving (Eq, Show)

data FParam a = FParam
    { fFreqs :: [a]
    , fAmps  :: [a]
    , fQs    :: [a]
    } deriving (Eq, Show)

fpToList :: FParam a -> [[a]]
fpToList f = [fFreqs f, fAmps f, fQs f]

listToFp :: [[a]] -> FParam a
listToFp l = FParam (l!!0) (l!!1) (l!!2)

data F a = F
    { fVoice :: Voice
    , fVowel :: Vowel
    , fParam :: FParam a
    } deriving (Eq, Show)

makeF :: (Floating a) => Voice -> Vowel -> [a] -> [a] -> [a] -> F a
makeF voiceP vowelP freqsP ampsP qsP =
    F voiceP vowelP $ FParam freqsP (map (\x -> 10.0**(x / 20.0)) ampsP) (zipWith (/) qsP freqsP)

getF :: Voice -> Vowel -> [F a] -> FParam a
getF voiceParam vowelParam formants = fParam
    $ head
    $ filter (\v -> fVoice v == voiceParam)
    $ filter (\v -> fVowel v == vowelParam)
    $ formants

--       x 
-- x0y0 --- x1y0
--  |    *   |   y 
-- x0y1 --- x1y1    
--interpFPQuad :: Float -> Float -> FParam -> FParam -> FParam -> FParam -> FParam
interpQuad :: (Fractional a) => a -> a -> [[a]] -> [[a]] -> [[a]] -> [[a]] -> [[a]]
interpQuad x y f00 f01 f10 f11 = -- listToFp $
        map (\(a,b,c,d) ->
                zipWith4 (\p00 p01 p10 p11 ->
                    p00*(1.0-x)*(1.0-y) + p01*x*(1.0-y) + p10*(1.0-x)*y + p11*x*y)
            a b c d) 
        $ zip4 f00 f01 f10 f11 


interpFPQuad :: (Fractional a) => a -> a -> FParam a -> FParam a -> FParam a -> FParam a -> FParam a
interpFPQuad x y f00 f01 f10 f11 = listToFp $ interpQuad x y (fpToList f00) (fpToList f01) (fpToList f10) (fpToList f11)

fundamentalFrequency :: (Num a) => Voice -> a
fundamentalFrequency x = case x of
    Bass         -> 100
    Tenor        -> 280
    CounterTenor -> 320
    Alto         -> 380
    Soprano      -> 580



formantTable =
    [ makeF Soprano      A [ 800, 1150, 2900, 3900, 4950 ] [  0,  -6, -32, -20, -50 ] [ 80,  90, 120, 130, 140 ]
    , makeF Soprano      E [ 350, 2000, 2800, 3600, 4950 ] [  0, -20, -15, -40, -56 ] [ 60, 100, 120, 150, 200 ]
    , makeF Soprano      I [ 270, 2140, 2950, 3900, 4950 ] [  0, -12, -26, -26, -44 ] [ 60,  90, 100, 120, 120 ]
    , makeF Soprano      O [ 450,  800, 2830, 3800, 4950 ] [  0, -11, -22, -22, -50 ] [ 70,  80 ,100, 130, 135 ]
    , makeF Soprano      U [ 325,  700, 2700, 3800, 4950 ] [  0, -16, -35, -40, -60 ] [ 50,  60, 170, 180, 200 ]
    , makeF Alto         A [ 800, 1150, 2800, 3500, 4950 ] [  0,  -4, -20, -36, -60 ] [ 80,  90, 120, 130, 140 ]
    , makeF Alto         E [ 400, 1600, 2700, 3300, 4950 ] [  0, -24, -30, -35, -60 ] [ 60,  80, 120, 150, 200 ]
    , makeF Alto         I [ 350, 1700, 2700, 3700, 4950 ] [  0, -20, -30, -36, -60 ] [ 50, 100, 120, 150, 200 ]
    , makeF Alto         O [ 450,  800, 2830, 3500, 4950 ] [  0,  -9, -16, -28, -55 ] [ 70,  80, 100, 130, 135 ]
    , makeF Alto         U [ 325,  700, 2530, 3500, 4950 ] [  0, -12, -30, -40, -64 ] [ 50,  60, 170, 180, 200 ]
    , makeF CounterTenor A [ 660, 1120, 2750, 3000, 3350 ] [  0,  -6, -23, -24, -38 ] [ 80,  90, 120, 130, 140 ]
    , makeF CounterTenor E [ 440, 1800, 2700, 3000, 3300 ] [  0, -14, -18, -20, -20 ] [ 70,  80, 100, 120, 120 ]
    , makeF CounterTenor I [ 270, 1850, 2900, 3350, 3590 ] [  0, -24, -24, -36, -36 ] [ 40,  90, 100, 120, 120 ]
    , makeF CounterTenor O [ 430,  820, 2700, 3000, 3300 ] [  0, -10, -26, -22, -34 ] [ 40,  80, 100, 120, 120 ]
    , makeF CounterTenor U [ 370,  630, 2750, 3000, 3400 ] [  0, -20, -23, -30, -34 ] [ 40,  60, 100, 120, 120 ]
    , makeF Tenor        A [ 650, 1080, 2650, 2900, 3250 ] [  0,  -6,  -7,  -8, -22 ] [ 80,  90, 120, 130, 140 ]
    , makeF Tenor        E [ 400, 1700, 2600, 3200, 3580 ] [  0, -14, -12, -14, -20 ] [ 70,  80, 100, 120, 120 ]
    , makeF Tenor        I [ 290, 1870, 2800, 3250, 3540 ] [  0, -15, -18, -20, -30 ] [ 40,  90, 100, 120, 120 ]
    , makeF Tenor        O [ 400,  800, 2600, 2800, 3000 ] [  0, -10, -12, -12, -26 ] [ 40,  80, 100, 120, 120 ]
    , makeF Tenor        U [ 350,  600, 2700, 2900, 3300 ] [  0, -20, -17, -14, -26 ] [ 40,  60, 100, 120, 120 ]
    , makeF Bass         A [ 600, 1040, 2250, 2450, 2750 ] [  0,  -7,  -9,  -9, -20 ] [ 60,  70, 110, 120, 130 ]
    , makeF Bass         E [ 400, 1620, 2400, 2800, 3100 ] [  0, -12,  -9, -12, -18 ] [ 40,  80, 100, 120, 120 ]
    , makeF Bass         I [ 250, 1750, 2600, 3050, 3340 ] [  0, -30, -16, -22, -28 ] [ 60,  90, 100, 120, 120 ]
    , makeF Bass         O [ 400,  750, 2400, 2600, 2900 ] [  0, -11, -21, -20, -40 ] [ 40,  80, 100, 120, 120 ]
    , makeF Bass         U [ 350,  600, 2400, 2675, 2950 ] [  0, -20, -32, -28, -36 ] [ 40,  80, 100, 120, 120 ]
    ]

testList = [getF Bass U formantTable, getF Bass O formantTable, getF Bass A formantTable, getF Bass E formantTable]
--testList = [FParam [1,2,3] [4,5,6] [7,8,9], FParam [11,22,33] [44,55,66] [77,88,99], FParam [111,222,333] [444,555,666] [777,888,999]]

argChain :: [FParam a] -> [[[a]]]
argChain ps = map transpose $ transpose $ map (fpToList) ps

argProgression :: (Fractional a) => [a] -> [a] -> FParam a -> FParam a -> FParam a -> FParam a -> [[[a]]]
argProgression xs ys f00 f01 f10 f11 = argChain $ map (\(x,y) -> interpFPQuad x y f00 f01 f10 f11) $ zip xs ys

zipWithMore :: (a -> a -> a) -> [a] -> [a] -> [a]
zipWithMore f (a:as) (b:bs) = f a b : zipWithMore f as bs
zipWithMore f []      bs      = bs -- if there's more in bs, use that
zipWithMore f as      []      = as -- if there's more in as, use that
