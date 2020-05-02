
(ns app.comp.circle-demo
  (:require [phlox.core
             :refer
             [defcomp hslx rect circle text container graphics create-list hslx g]]
            [app.comp.reset :refer [comp-reset]]))

(defn generate-circle-ops [idx]
  (loop [angle 0, acc []]
    (if (> angle (+ js/Math.PI -0.3 (rand 1.4)))
      acc
      (let [ratio (/ 1 (inc idx))
            a1 (+ angle (* 0.4 ratio))
            a2 (+ a1 (* 6 ratio (js/Math.random)))
            r0 (/ 180 js/Math.PI)]
        (recur
         (+ a2 (* 0.2 ratio))
         (conj
          acc
          (g :line-style {:color (* (js/Math.random) (hslx 0 0 100)), :width 6, :alpha 0})
          (g
           :arc
           {:center [0 0],
            :radius (* 8 idx),
            :angle [(* r0 angle) (* r0 a1)],
            :anticlockwise? false})
          (g :line-style {:color (* (js/Math.random) (hslx 0 0 100)), :width 4, :alpha 1})
          (g
           :arc
           {:center [0 0],
            :radius (* 8 idx),
            :angle [(* r0 a1) (* r0 a2)],
            :anticlockwise? false})))))))

(defcomp
 comp-circle-demo
 (touch-key)
 (container
  {:position [0 140]}
  (comp-reset [-80 -100])
  (create-list
   :container
   {}
   (->> (range 60)
        (map
         (fn [idx] [idx (graphics {:position [500 0], :ops (generate-circle-ops idx)})]))))))
