
(ns app.util )

(defn add-path [[a b] [x y]] [(+ a x) (+ b y)])

(defn multiply-path [[a b] [x y]] [(- (* a x) (* b y)) (+ (* a y) (* b x))])
