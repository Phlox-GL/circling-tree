
(ns app.comp.cycloid-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util :refer [rand-point add-path subtract-path multiply-path]]))

(defcomp
 comp-cycloid-demo
 (touch-key)
 (container
  {}
  (graphics
   {:position [400 400],
    :ops (let [r1 (+ 20 (rand 400))
               r2 (+ 20 (rand 400))
               r3 (+ 20 (rand 400))
               tt1 (rand 6)
               tt2 (rand 6)
               trail (->> (range 10000)
                          (map
                           (fn [idx]
                             (let [t (* idx 0.05)
                                   dr (- r1 r2)
                                   dr2 (- r2 r3)
                                   t2 (+ tt1 (unchecked-negate (/ (* t r1) r2)))
                                   t3 (+ tt2 (unchecked-negate (/ (* t2 r3) r3)))]
                               (add-path
                                (add-path
                                 [(* dr (js/Math.cos t)) (* dr (js/Math.sin t))]
                                 [(* dr2 (js/Math.cos t2)) (* dr2 (js/Math.sin t2))])
                                [(* r3 (js/Math.cos t3)) (* r3 (js/Math.sin t3))])))))]
      (vec
       (concat
        [(g :line-style {:color (rand-int (hslx 0 0 100)), :width 2, :alpha 0.8})
         (g :move-to (first trail))]
        (->> trail rest (mapcat (fn [p] [(g :line-to p)]))))))})
  (comp-reset [-40 40])))
