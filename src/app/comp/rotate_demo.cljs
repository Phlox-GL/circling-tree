
(ns app.comp.rotate-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util :refer [rand-point]]))

(defcomp
 comp-rotate-demo
 (touch-key)
 (container
  {}
  (create-list
   :container
   {:position [400 280]}
   (let [randon-lines (->> (range 2)
                           (mapcat
                            (fn [idx]
                              [(g :move-to (rand-point 100))
                               (g
                                :bezier-to
                                {:p1 (rand-point 200),
                                 :p2 (rand-point 200),
                                 :to-p (rand-point 100)})
                               (g :move-to (rand-point 200))
                               (g
                                :bezier-to
                                {:p1 (rand-point 400),
                                 :p2 (rand-point 400),
                                 :to-p (rand-point 200)})
                               (g :move-to (rand-point 300))
                               (g
                                :bezier-to
                                {:p1 (rand-point 600),
                                 :p2 (rand-point 600),
                                 :to-p (rand-point 300)})])))]
     (->> (range 20)
          (map
           (fn [idx]
             [idx
              (graphics
               {:ops (vec
                      (concat
                       [(g :line-style {:color (hslx (rand 360) 80 70), :width 2, :alpha 1})]
                       randon-lines)),
                :rotation (* idx 0.1 js/Math.PI)})])))))
  (comp-reset [0 100])))
