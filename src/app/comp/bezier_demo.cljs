
(ns app.comp.bezier-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util :refer [rand-point add-path subtract-path divide-x multiply-path]]))

(defcomp
 comp-bezier-demo
 (touch-key)
 (container
  {}
  (graphics
   {:position [600 400],
    :ops (let [p1 (rand-point 800)
               p2 (rand-point 800)
               q1 (rand-point 800)
               q2 (rand-point 800)
               n 80
               p-unit (divide-x (subtract-path p2 p1) n)
               q-unit (divide-x (subtract-path q1 q2) n)]
      (vec
       (concat
        []
        (->> (range (inc n))
             (mapcat
              (fn [idx]
                (let [p3 (add-path p1 (multiply-path p-unit [idx 0]))
                      q3 (add-path q2 (multiply-path q-unit [idx 0]))
                      m-unit (divide-x (subtract-path q3 p3) n)
                      mp (add-path p3 (multiply-path m-unit [idx 0]))]
                  [(g :move-to p3)
                   [:line-style {:color (rand-int (hslx 0 0 100)), :width 3, :alpha 0.2}]
                   (g :line-to mp)
                   [:line-style {:color (rand-int (hslx 0 0 100)), :width 4, :alpha 0.8}]
                   (g :line-to q3)])))))))})
  (comp-reset [-40 40])))
