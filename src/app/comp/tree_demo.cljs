
(ns app.comp.tree-demo
  (:require [phlox.core
             :refer
             [defcomp >> g hslx rect circle text container graphics create-list hslx]]
            [app.util :refer [add-path multiply-path subtract-path divide-path rough-size]]
            [phlox.comp.drag-point :refer [comp-drag-point]]))

(defn generate-branches [from arrow level factor-1 factor-2]
  (let [next-from (add-path from arrow)
        next-p1 (add-path next-from (multiply-path factor-1 arrow))
        next-p2 (add-path next-from (multiply-path factor-2 arrow))
        trail [(g :move-to next-p1) (g :line-to next-from) (g :line-to next-p2)]
        too-deep? (or (> level 8) (< (rough-size arrow) 4))]
    (if too-deep?
      trail
      (concat
       trail
       (generate-branches
        next-from
        (multiply-path factor-1 arrow)
        (inc level)
        factor-1
        factor-2)
       (generate-branches
        next-from
        (multiply-path factor-2 arrow)
        (inc level)
        factor-1
        factor-2)))))

(defcomp
 comp-tree-demo
 (states)
 (let [cursor (:cursor states)
       state (or (:data states) {:p1 [0.7 0.2], :p2 [0.84 0.15], :p0 [3 -80]})
       p0 (:p0 state)
       base (subtract-path [0 0] p0)
       factor-1 (divide-path (:p1 state) base)
       factor-2 (divide-path (:p2 state) base)]
   (container
    {:position [400 400]}
    (graphics
     {:position [0 0],
      :ops (let [trail [[:move-to [0 0]]
                        [:line-style {:color (hslx 0 0 100), :width 1, :alpha 1}]
                        [:line-to p0]]]
        (concat trail (generate-branches p0 base 0 factor-1 factor-2)))})
    (comp-drag-point
     (>> states :p1)
     {:position (:p1 state),
      :on-change (fn [position d!] (d! cursor (assoc state :p1 position)))})
    (comp-drag-point
     (>> states :p2)
     {:position (:p2 state),
      :title "end",
      :on-change (fn [position d!] (d! cursor (assoc state :p2 position)))})
    (comp-drag-point
     (>> states :p0)
     {:position (:p0 state),
      :title "from",
      :on-change (fn [position d!] (d! cursor (assoc state :p0 position)))}))))

(defn should-shrink? [level]
  (cond (< level 4) false (> level 8) true :else (> (rand 2) 1.4)))
