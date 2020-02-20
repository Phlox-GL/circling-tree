
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
   (let [randon-lines (->> (range 4)
                           (mapcat
                            (fn [idx]
                              [(g :move-to [(rand 60) (rand 60)])
                               (g
                                :bezier-to
                                {:p1 [(rand 300) (rand 300)],
                                 :p2 [(rand 200) (rand 200)],
                                 :to-p [(rand 100) (rand 100)]})
                               (g :move-to [(rand 200) (rand 200)])
                               (g
                                :bezier-to
                                {:p1 [(rand 600) (rand 600)],
                                 :p2 [(rand 400) (rand 400)],
                                 :to-p [(rand 200) (rand 200)]})])))]
     (->> (range 220)
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
