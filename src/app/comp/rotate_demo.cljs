
(ns app.comp.rotate-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util :refer [rand-point]]
            [phlox.comp.drag-point :refer [comp-drag-point]]
            [phlox.comp.slider :refer [comp-slider]]))

(defn gen-trail [points alpha]
  [(g :move-to (get points 0))
   (g :line-style {:color (hslx 0 100 70), :width 2, :alpha alpha})
   (g :bezier-to {:p1 (get points 1), :p2 (get points 2), :to-p (get points 3)})
   (g :move-to (get points 4))
   (g :line-style {:color (hslx 120 100 70), :width 2, :alpha alpha})
   (g :bezier-to {:p1 (get points 5), :p2 (get points 6), :to-p (get points 7)})
   (g :move-to (get points 8))
   (g :line-style {:color (hslx 240 100 70), :width 2, :alpha alpha})
   (g :bezier-to {:p1 (get points 9), :p2 (get points 10), :to-p (get points 11)})])

(defcomp
 comp-rotate-demo
 (cursor states)
 (let [state (or (:data states)
                 {:points (->> (range 12)
                               (map (fn [idx] [(+ 200 (rand 100)) (rand 100)]))
                               (vec)),
                  :steps 18,
                  :base 20,
                  :alpha 1})
       points (:points state)]
   (container
    {:position [400 400]}
    (create-list
     :container
     {}
     (let []
       (->> (range (:steps state))
            (map
             (fn [idx]
               [idx
                (graphics
                 {:ops (gen-trail points (:alpha state)), :angle (* idx (:base state))})])))))
    (create-list
     :container
     {}
     (->> points
          (map-indexed
           (fn [idx point]
             [idx
              (comp-drag-point
               (conj cursor idx)
               (get states idx)
               {:position point,
                :fill (hslx (cond (< idx 4) 0 (< idx 8) 120 :else 240) 100 70),
                :on-change (fn [v d!] (d! cursor (assoc-in state [:points idx] v)))})]))))
    (create-list
     :container
     {}
     (->> [:steps :base :alpha]
          (map-indexed
           (fn [idx param]
             [param
              (comp-slider
               (conj cursor param)
               (get states param)
               {:title (name param),
                :value (get state param),
                :unit (case param :steps 0.4 :alpha 0.004 :base 0.2 1),
                :on-change (fn [v d!]
                  (d!
                   cursor
                   (assoc
                    state
                    param
                    (case param :steps (max 1 (js/Math.round v)) :alpha (max 0 (min 1 v)) v)))),
                :position [(+ -400 (* idx 140)) -440]})])))))))
