
(ns app.comp.bezier-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util :refer [rand-point add-path subtract-path divide-x multiply-path]]
            [phlox.comp.drag-point :refer [comp-drag-point]]
            [phlox.comp.slider :refer [comp-slider]]))

(defn gen-trail [p1 p2 q1 q2 n]
  (let [p-unit (divide-x (subtract-path p2 p1) n), q-unit (divide-x (subtract-path q1 q2) n)]
    (->> (range (inc n))
         (mapcat
          (fn [idx]
            (let [p3 (add-path p1 (multiply-path p-unit [idx 0]))
                  q3 (add-path q2 (multiply-path q-unit [idx 0]))
                  m-unit (divide-x (subtract-path q3 p3) n)
                  mp (add-path p3 (multiply-path m-unit [idx 0]))]
              [(g :move-to p3)
               [:line-style {:color (hslx 200 100 70), :width 3, :alpha 0.3}]
               (g :line-to mp)
               [:line-style {:color (hslx 20 100 70), :width 3, :alpha 0.9}]
               (g :line-to q3)]))))))

(defcomp
 comp-bezier-demo
 (cursor states)
 (let [state (or (:data states) {:points [[100 100] [400 100] [400 400] [100 400]], :n 80})]
   (container
    {}
    (graphics
     {:position [0 0],
      :ops (let [[p1 p2 q1 q2] (:points state), n (:n state)] (gen-trail p1 p2 q1 q2 n))})
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
                :on-change (fn [value d!] (d! cursor (assoc-in state [:points idx] value)))})]))))
    (comp-slider
     (conj cursor :n)
     (get states :n)
     {:title "n",
      :position [200 -40],
      :value (:n state),
      :unit 0.3,
      :round? true,
      :on-change (fn [value d!] (d! cursor (assoc state :n (max 1 (js/Math.round value)))))}))))
