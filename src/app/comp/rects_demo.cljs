
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
   {:position [200 40]}
   (->> (range 10)
        (mapcat
         (fn [x]
           (->> (range 10)
                (map
                 (fn [y]
                   [(str x "+" y)
                    (container
                     {:position [(* x 60) (* y 60)]}
                     (rect
                      {:size [(* 15 (rand-int 16)) (* 15 (rand-int 16))],
                       :angle (* 45 (rand-int 4)),
                       :position [(* 15 (rand-int 4)) (* 15 (rand-int 4))],
                       :line-style {:color (rand (hslx 0 0 100)),
                                    :width (rand-int 4),
                                    :alpha 1},
                       :alpha 1})
                     (rect
                      {:size [(* 15 (rand-int 4)) (* 15 (rand-int 4))],
                       :position [(* 15 (rand-int 6)) (* 15 (rand-int 6))],
                       :fill (rand (hslx 0 0 100)),
                       :angle (* 45 (rand-int 4)),
                       :alpha 0.9})
                     (rect
                      {:size [(* 15 (inc (rand-int 2))) (* 15 (inc (rand-int 2)))],
                       :position [(* 15 (rand-int 16)) (* 15 (rand-int 16))],
                       :angle (* 45 (rand-int 4)),
                       :alpha 1,
                       :line-style {:color (rand (hslx 0 0 100)), :width 2, :alpha 1}}))])))))))
  (comp-reset [-40 40])))
