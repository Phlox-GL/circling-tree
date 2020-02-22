
(ns app.comp.tree-demo
  (:require [phlox.core
             :refer
             [defcomp g hslx rect circle text container graphics create-list hslx]]
            [app.util :refer [add-path multiply-path]]
            [app.comp.reset :refer [comp-reset]]))

(defn shoud-shrink? [level]
  (cond (< level 4) false (> level 8) true :else (> (rand 2) 1.4)))

(defn generate-branches [p arrow ops level]
  (let [get-branch (fn [v1]
                     (let [arrow1 (multiply-path arrow v1)
                           p1 (add-path p arrow1)
                           r (+ (/ 12 level) 6)
                           line-ops (concat
                                     [(g :move-to p)
                                      (g
                                       :line-style
                                       {:color (hslx 0 0 60), :width 2, :alpha 0.6})
                                      (g :line-to p1)]
                                     (if (> (rand 2) 1.2)
                                       [(g
                                         :move-to
                                         [(+ (first p1) (* r (js/Math.cos -1)))
                                          (- (peek p1) (+ r (js/Math.sin -1)))])
                                        (g
                                         :line-style
                                         {:color (rand (hslx 0 0 100)), :width 4, :alpha 1})
                                        (g
                                         :arc
                                         {:center p1,
                                          :radius r,
                                          :angle [-1 4.8],
                                          :anticlockwise? false})]))]
                       (if (shoud-shrink? level)
                         line-ops
                         (generate-branches p1 arrow1 line-ops (inc level)))))]
    (concat
     ops
     (get-branch [(+ 0.7 (rand 0.3)) (+ -0.4 (rand 0.3))])
     (get-branch [(+ 0.84 (rand 0.2)) (+ 0.15 (rand 0.3))]))))

(defcomp
 comp-tree-demo
 (touch-key)
 (container
  {:position [0 0]}
  (graphics
   {:position [400 600],
    :ops (let [p0 [3 -80]
               ops0 [[:move-to [0 0]]
                     [:line-style {:color (hslx 0 0 100), :width 1, :alpha 1}]
                     [:line-to p0]]]
      (vec (generate-branches p0 p0 ops0 0)))})
  (comp-reset [0 0])))
