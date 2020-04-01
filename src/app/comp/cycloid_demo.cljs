
(ns app.comp.cycloid-demo
  (:require [phlox.core
             :refer
             [defcomp >> hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util :refer [rand-point add-path subtract-path multiply-path]]
            [app.comp.button :refer [comp-button]]
            [phlox.comp.slider :refer [comp-slider]]))

(defn get-round? [param] (case param :r1 true :r2 true :r3 true :steps true (do false)))

(defn get-unit [param] (case param :r1 0.4 :r2 0.2 :r3 0.08 :steps 20 :v 0.004 1))

(defn round-value [v param] (case param :steps (js/Math.max 0 (js/Math.round v)) v))

(defcomp
 comp-numbers-control
 (state states)
 (let [cursor (:cursor states), params [:r1 :r2 :r3 :steps :v]]
   (container
    {:position [0 -80]}
    (create-list
     :container
     {}
     (->> params
          (map-indexed
           (fn [idx param]
             [idx
              (comp-slider
               (>> states idx)
               {:value (get state param),
                :position [(* idx 140) 30],
                :unit (get-unit param),
                :round? (get-round? param),
                :title (name param),
                :on-change (fn [v d!] (d! cursor (assoc state param (round-value v param))))})])))))))

(defcomp
 comp-cycloid-demo
 (states)
 (let [cursor (:cursor states)
       state (or (:data states) {:r1 312, :r2 80, :r3 96, :steps 2000, :v 0.11})]
   (container
    {}
    (graphics
     {:position [400 400],
      :ops (let [r1 (:r1 state)
                 r2 (:r2 state)
                 r3 (:r3 state)
                 trail (->> (range (:steps state))
                            (map
                             (fn [idx]
                               (let [t (* idx (:v state))
                                     dr (- r1 r2)
                                     dr2 (- r2 r3)
                                     t2 (unchecked-negate (/ (* t r1) r2))
                                     t3 (unchecked-negate (/ (* t2 r2) r3))]
                                 (add-path
                                  (add-path
                                   [(* dr (js/Math.cos t)) (* dr (js/Math.sin t))]
                                   (if (zero? r2)
                                     [0 0]
                                     [(* dr2 (js/Math.cos t2)) (* dr2 (js/Math.sin t2))]))
                                  (if (zero? r3)
                                    [0 0]
                                    [(* r3 (js/Math.cos t3)) (* r3 (js/Math.sin t3))]))))))]
        (concat
         [(g :line-style {:color (hslx 0 80 70), :width 2, :alpha 0.7})
          (g :move-to (or (first trail) [0 0]))]
         (->> trail rest (mapcat (fn [p] [(g :line-to p)])))))})
    (comp-numbers-control state states))))
