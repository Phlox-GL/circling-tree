
(ns app.comp.rects-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util :refer [rand-point]]))

(defcomp
 comp-rects-demo
 (touch-key)
 (container
  {}
  (create-list
   :container
   {:position [400 280]}
   (->> (range 18)
        (map
         (fn [idx]
           [idx
            (container
             {:angle (* 20 idx)}
             (rect
              {:position [100 20],
               :size [160 50],
               :fill (hslx 0 0 90),
               :alpha 0.3,
               :line-style {:width 2, :color (hslx 0 0 90), :alpha 0.1}})
             (rect
              {:position [40 0],
               :size [20 120],
               :fill (hslx 0 0 90),
               :alpha 0.3,
               :line-style {:width 2, :color (hslx 0 0 90), :alpha 0.1}})
             (rect
              {:position [170 -80],
               :size [20 180],
               :fill (hslx 0 0 90),
               :alpha 0.3,
               :line-style {:width 2, :color (hslx 0 0 90), :alpha 0.1}})
             (rect
              {:position [200 0],
               :size [20 200],
               :fill (hslx 0 0 90),
               :alpha 0.3,
               :line-style {:width 2, :color (hslx 0 0 90), :alpha 0.1}})
             (rect
              {:position [240 -80],
               :size [100 10],
               :fill (hslx 0 0 90),
               :alpha 0.3,
               :line-style {:width 2, :color (hslx 0 0 90), :alpha 0.1}})
             (circle {:radius 8, :position [10 90], :fill (hslx 0 0 90), :alpha 0.4})
             (circle {:radius 16, :position [260 90], :fill (hslx 0 0 90), :alpha 0.4}))]))))
  (comp-reset [-40 40])))
