
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
   (let [randon-lines (->> (range 3)
                           (mapcat
                            (fn [idx]
                              [(g :move-to [(rand 160) (rand 100)])
                               (g
                                :bezier-to
                                {:p1 [(rand 180) (rand 300)],
                                 :p2 [(rand 180) (rand 300)],
                                 :to-p [(rand 160) (rand 80)]})
                               (g :move-to [(rand 80) (rand 40)])
                               (g
                                :bezier-to
                                {:p1 [(rand 400) (rand 300)],
                                 :p2 [(rand 400) (rand 200)],
                                 :to-p [(rand 160) (rand 120)]})
                               (g :move-to [(rand 320) (rand 320)])
                               (g
                                :bezier-to
                                {:p1 [(rand 600) (rand 400)],
                                 :p2 [(rand 600) (rand 300)],
                                 :to-p [(rand 400) (rand 320)]})])))]
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
