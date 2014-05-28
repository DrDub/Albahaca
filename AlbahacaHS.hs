module AlbahacaHS where

import Prelude

data Point = Point { x :: Double , y :: Double }
data Direction = Direction { dx :: Double , dy :: Double }

instance Eq Point where
  (Point x1 y1) == (Point x2 y2) = (x1 == x2) && (y1 == y2)

wander :: Int-> [ [Point] ] -> [ (Point, Direction) ]
wander seed ps = wander0 (randoms seed) ps (Point max_x 0) (Point (max_x-10) 0)
  where
    max_x = foldl1 max (map (\(Point a b)->a) (concat ps))
    max_y = foldl1 max (map (\(Point a b)->b) (concat ps))
    
wander0 :: [Int] -> [ [Point] ] -> Point -> Point -> [ (Point, Direction) ]
wander0 _ [] _ _ = []
wander0 rnds ps currentp prevp =
    newp_dir : (wander0 rnds' ps' next_point currentp)
  where
    close_points = head (filter (\l->not(null l)) (map intersection_at [1..]))
    rnd = head rnds
    rnds' = tail rnds
    next_point = close_points !! (rnd `mod` (length close_points))
    ps' = filter (\l->not(null l)) (map (filter (\px-> px /= next_point)) ps)
    forward_p = (Point (x currentp + delta_x * 10 ) (y currentp + delta_y * 10))
      where
        fdelta_x = (x currentp) - (x prevp)
        fdelta_y = (y currentp) - (y prevp)
        size = sqrt(fdelta_x * fdelta_x + fdelta_y * fdelta_y)
        delta_x = fdelta_x / size
        delta_y = fdelta_y / size
    intersection_at i = filter (\px -> (dist px forward_p) < i) (concat ps)
    newp_dir = (currentp, (Direction ((x currentp) - (x next_point)) ((y currentp)-(y next_point))) )
    
dist (Point ax ay) (Point bx by) = sqrt((ax-bx)*(ax-bx) + (ay-by)*(ay-by))

next :: Int -> Int
next n = (1103515245 * n + 12345) `mod` 1073741824

randoms :: Int -> [Int]
randoms seed = iterate next seed

