
(ns app.comp.tree-demo
  (:require [phlox.core
             :refer
             [defcomp hslx rect circle text container graphics create-list hslx]]))

(defn add-path [[a b] [x y]] [(+ a x) (+ b y)])

(defn multiply-path [[a b] [x y]] [(- (* a x) (* b y)) (+ (* a y) (* b x))])

(defn shoud-shrink? [level]
  (cond (< level 4) false (> level 8) true :else (> (rand 2) 1.4)))

(defn generate-branches [p arrow ops level]
  (let [get-branch (fn [v1]
                     (let [arrow1 (multiply-path arrow v1)
                           p1 (add-path p arrow1)
                           line-ops (concat
                                     [[:move-to p]
                                      [:line-style
                                       {:color (hslx 0 0 60), :width 2, :alpha 0.6}]
                                      [:line-to p1]]
                                     (if (> (rand 2) 1.2)
                                       [[:line-style {:color 0, :width 0, :alpha 0}]
                                        [:arc {:center p1, :radius 22, :angle [1 -1]}]
                                        [:line-style
                                         {:color (rand (hslx 0 0 100)),
                                          :width 4,
                                          :alpha (rand 1)}]
                                        [:arc {:center p1, :radius 22, :angle [-1 4.8]}]]))]
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
  {:position [300 600]}
  (graphics
   {:position [0 0],
    :ops (let [p0 [3 -80]
               ops0 [[:move-to [0 0]]
                     [:line-style {:color (hslx 0 0 100), :width 1, :alpha 1}]
                     [:line-to p0]]]
      (vec (generate-branches p0 p0 ops0 0)))})
  (container
   {:position [-440 -200]}
   (rect
    {:position [0 0],
     :size [80 40],
     :fill (hslx 0 0 40),
     :on {:click (fn [e d!] (d! :touch nil))}})
   (text
    {:text "Reset",
     :position [8 4],
     :style {:font-family "Josefin Sans", :fill (hslx 0 0 100)}}))))
