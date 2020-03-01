
(ns app.util )

(defn add-path [[a b] [x y]] [(+ a x) (+ b y)])

(defn divide-path [[x y] [a b]]
  (let [inverted (/ 1 (+ (* a a) (* b b)))]
    [(* inverted (+ (* x a) (* y b))) (* inverted (- (* y a) (* x b)))]))

(defn divide-x [point x] [(/ (first point) x) (/ (peek point) x)])

(defn multiply-path [[a b] [x y]] [(- (* a x) (* b y)) (+ (* a y) (* b x))])

(defn rand-color [] (rand-int 0xffffff))

(defn rand-point
  ([n] (rand-point n n))
  ([n m]
   [(- (js/Math.round (* 0.2 n)) (rand-int n)) (- (js/Math.round (* 0.2 m)) (rand-int m))]))

(defn subtract-path [[a b] [x y]] [(- a x) (- b y)])
