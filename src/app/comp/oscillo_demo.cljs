
(ns app.comp.oscillo-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.util :refer [rand-point rand-color]]
            [app.comp.button :refer [comp-button]]
            [phlox.comp.slider :refer [comp-slider]]))

(defn get-round? [param] (case param :unit false (do true)))

(defcomp
 comp-oscillo-control
 (cursor state states)
 (container
  {}
  (create-list
   :container
   {}
   (->> [:m :n :step :unit]
        (map-indexed
         (fn [idx param]
           [idx
            (comp-slider
             (conj cursor param)
             (get states param)
             {:value (get state param),
              :title (name param),
              :position [(* 140 idx) 0],
              :round? (get-round? param),
              :unit (case param :unit 0.001 :step 1 0.1),
              :on-change (fn [value d!]
                (d!
                 cursor
                 (assoc
                  state
                  param
                  (case param
                    :m (max 1 (js/Math.round value))
                    :n (max 1 (js/Math.round value))
                    :step (max 1 (js/Math.round value))
                    (max 0 value)))))})]))))
  (comp-button
   {:text "Random",
    :position [580 0],
    :on-click (fn [e d!]
      (d! cursor {:m (rand-int 40), :n (rand-int 40), :step 500, :unit 0.01}))})))

(def initial-state {:step 1000, :unit 0.01, :m 13, :n 3})

(defcomp
 comp-oscillo-demo
 (cursor states)
 (let [state (or (:data states) initial-state)]
   (container
    {}
    (graphics
     {:position [400 360],
      :ops (let [step (:step state)
                 r 200
                 m (:m state)
                 n (:n state)
                 unit (:unit state)
                 trail (->> (range step)
                            (map
                             (fn [idx]
                               (let [t (* idx unit)]
                                 [(* r (js/Math.cos (* m t))) (* r (js/Math.sin (* n t)))]))))]
        (concat
         [(g :move-to (first trail))
          (g :line-style {:color (rand-color), :width 2, :alpha 1})]
         (->> trail rest (map (fn [point] [:line-to point])))))})
    (comp-oscillo-control cursor state states))))
