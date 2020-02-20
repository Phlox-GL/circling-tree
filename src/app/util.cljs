
(ns app.util )

(defn add-path [[a b] [x y]] [(+ a x) (+ b y)])

(defn multiply-path [[a b] [x y]] [(- (* a x) (* b y)) (+ (* a y) (* b x))])

(defn rand-point
  ([n] (rand-point n n))
  ([n m]
   [(- (js/Math.round (* 0.2 n)) (rand-int n)) (- (js/Math.round (* 0.2 m)) (rand-int m))]))
