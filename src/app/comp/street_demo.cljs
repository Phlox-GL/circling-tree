
(ns app.comp.street-demo
  (:require [phlox.core
             :refer
             [defcomp g hslx rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util :refer [rand-point]]))

(defn buzz [x] (- (* 0.5 x) (rand x)))

(defcomp
 comp-street-demo
 (touch-key)
 (container
  {:position [0 0]}
  (create-list
   :container
   {:position [400 100]}
   (->> (range 200)
        (map
         (fn [idx]
           [idx
            (let [seed (buzz 1000)
                  x (* seed (* seed 0.002) (* seed 0.002) (* seed 0.002) (* seed 0.002))]
              (rect
               {:position [x (+ 300 (* -1 (js/Math.abs x) 0.026 (rand 80)))],
                :size [(+ 4 (* (js/Math.abs x) (+ 0.01 (rand 0.3))))
                       (+ 4 (* 0.26 (js/Math.abs x) (+ 3 (rand 1))))],
                :fill (hslx (+ 160 (rand 160)) (+ 40 (rand 60)) (+ 70 (rand 30))),
                :alpha (+ 0.4 (rand 6))}))]))))
  (comp-reset [200 0])))
