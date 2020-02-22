
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
   {:position [400 400]}
   (let [random-lines (->> (range 1)
                           (mapcat
                            (fn [idx]
                              [(g :move-to (rand-point 400))
                               (g :begin-fill {:color (rand (hslx 0 0 100)), :alpha 0.1})
                               (g
                                :bezier-to
                                {:p1 (rand-point 600),
                                 :p2 (rand-point 600),
                                 :to-p (rand-point 400)})
                               (g :move-to (rand-point 300))
                               (g
                                :bezier-to
                                {:p1 (rand-point 600),
                                 :p2 (rand-point 600),
                                 :to-p (rand-point 300)})
                               (g :move-to (rand-point 200))
                               (g
                                :bezier-to
                                {:p1 (rand-point 400),
                                 :p2 (rand-point 400),
                                 :to-p (rand-point 200)})
                               (g :move-to (rand-point 400))
                               (g
                                :bezier-to
                                {:p1 (rand-point 600),
                                 :p2 (rand-point 600),
                                 :to-p (rand-point 400)})])))]
     (->> (range 16)
          (map
           (fn [idx]
             [idx
              (graphics
               {:ops (vec
                      (concat
                       [(g :line-style {:color (hslx (rand 360) 80 70), :width 2, :alpha 1})]
                       random-lines)),
                :angle (* idx 22.5)})])))))
  (comp-reset [-40 40])))
