
(ns app.comp.rotate-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]))

(defcomp
 comp-rotate-demo
 (touch-key)
 (container
  {}
  (create-list
   :container
   {:position [400 280]}
   (->> (range 20)
        (map
         (fn [idx]
           [idx
            (graphics
             {:ops [(g :line-style {:color (hslx (rand 360) 80 70), :width 4, :alpha 1})
                    (g :move-to [0 -4])
                    (g :bezier-to {:p1 [40 -40], :p2 [120 90], :to-p [200 0]})
                    (g :bezier-to {:p1 [240 -40], :p2 [400 400], :to-p [160 -40]})
                    (g :bezier-to {:p1 [100 -50], :p2 [220 90], :to-p [100 80]})
                    (g :bezier-to {:p1 [40 80], :p2 [30 -80], :to-p [0 -4]})],
              :rotation (* idx 0.1 js/Math.PI)})]))))
  (comp-reset [0 100])))
