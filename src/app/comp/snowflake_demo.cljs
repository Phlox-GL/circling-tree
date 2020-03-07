
(ns app.comp.snowflake-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util
             :refer
             [rand-point add-path subtract-path divide-x multiply-path divide-path invert-y]]
            [phlox.comp.drag-point :refer [comp-drag-point]]
            [phlox.comp.button :refer [comp-button]]
            [phlox.comp.slider :refer [comp-slider]]
            [phlox.comp.switch :refer [comp-switch]]))

(defn fold-curve [points steps shaking?]
  (let [template-points (->> (rest points)
                             (map (fn [point] (subtract-path point (first points)))))
        template-path (last template-points)
        inverted (divide-path [1 0] template-path)]
    (loop [t steps, acc points]
      (if (<= t 0)
        acc
        (recur
         (dec t)
         (let [acc-vec (vec acc)]
           (concat
            [(first acc)]
            (->> (rest acc)
                 (map-indexed
                  (fn [idx point]
                    (let [from (get acc-vec idx)]
                      (->> template-points
                           (map
                            (fn [pi]
                              (add-path
                               from
                               (multiply-path
                                (subtract-path point from)
                                (if (and shaking? (odd? idx))
                                  (invert-y (multiply-path pi inverted))
                                  (multiply-path pi inverted))))))))))
                 (mapcat identity)))))))))

(defcomp
 comp-snowflake-demo
 (cursor states)
 (let [state (or (:data states) {:steps 1, :points [[40 300] [440 300]], :shaking? false})]
   (container
    {}
    (container
     {:position [0 -60]}
     (comp-button
      {:text "Add",
       :on {:click (fn [e d!]
              (d!
               cursor
               (update
                state
                :points
                (fn [points]
                  (conj (pop points) (add-path (last points) [-100 100]) (last points))))))}})
     (comp-button
      {:text "Reduce",
       :position [80 0],
       :on {:click (fn [e d!]
              (d!
               cursor
               (update
                state
                :points
                (fn [points]
                  (if (<= (count points) 2) points (conj (pop (pop points)) (last points)))))))}})
     (comp-slider
      (conj cursor :steps)
      (:steps states)
      {:value (:steps state),
       :position [180 0],
       :unit 0.1,
       :title "Steps",
       :min 0,
       :max (if (>= 3 (count (:points state))) 12 6),
       :round? true,
       :on-change (fn [value d!] (d! cursor (assoc state :steps value)))})
     (comp-switch
      {:value (:shaking? state),
       :position [340 0],
       :title "Shake",
       :on-change (fn [v d!] (d! cursor (assoc state :shaking? v)))}))
    (graphics
     {:position [0 0],
      :ops (let [trail (fold-curve (:points state) (:steps state) (:shaking? state))]
        (concat
         [(g :move-to (first trail))
          (g :line-style {:color (hslx 0 0 100), :width 1, :alpha 1})]
         (->> (rest trail) (map-indexed (fn [idx point] (g :line-to point))))))})
    (create-list
     :container
     {}
     (->> (:points state)
          (map-indexed
           (fn [idx point]
             [idx
              (comp-drag-point
               (conj cursor idx)
               (get states idx)
               {:position point,
                :on-change (fn [position d!]
                  (d! cursor (assoc-in state [:points idx] position)))})])))))))
