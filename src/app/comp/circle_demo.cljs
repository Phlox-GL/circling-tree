
(ns app.comp.circle-demo
  (:require [phlox.core
             :refer
             [defcomp hslx rect circle text container graphics create-list hslx g]]))

(defn generate-circle-ops [idx]
  (loop [angle 0, acc []]
    (if (> angle (+ js/Math.PI -0.3 (* 1.4 (js/Math.random))))
      acc
      (let [ratio (/ 1 (inc idx))
            a1 (+ angle (* 0.4 ratio))
            a2 (+ a1 (* 6 ratio (js/Math.random)))]
        (recur
         (+ a2 (* 0.2 ratio))
         (conj
          acc
          (g :line-style {:color (* (js/Math.random) (hslx 0 0 100)), :width 3, :alpha 0})
          (g
           :arc
           {:center [0 0], :radius (* 8 idx), :angle [angle a1], :anticlockwise? false})
          (g :line-style {:color (* (js/Math.random) (hslx 0 0 100)), :width 4, :alpha 1})
          (g :arc {:center [0 0], :radius (* 8 idx), :angle [a1 a2], :anticlockwise? false})))))))

(defcomp
 comp-circle-demo
 (touch-key)
 (container
  {:position [0 140]}
  (container
   {:position [-200 200]}
   (rect
    {:position [0 0],
     :size [80 40],
     :fill (hslx 0 0 30),
     :on {:click (fn [e d!] (d! :touch nil))}})
   (text
    {:text "Reset",
     :position [8 8],
     :style {:fill (hslx 0 0 90), :font-family "Josefin Sans", :font-size 20}}))
  (create-list
   :container
   {}
   (->> (range 60)
        (map
         (fn [idx] [idx (graphics {:position [500 0], :ops (generate-circle-ops idx)})]))))))
