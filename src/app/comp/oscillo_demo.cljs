
(ns app.comp.oscillo-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.util :refer [rand-point rand-color]]
            [app.comp.button :refer [comp-button]]))

(defcomp
 comp-oscillo-control
 (cursor state)
 (let [selected (get state :selected)]
   (container
    {}
    (create-list
     :container
     {}
     (->> [:m :n :step :unit]
          (map-indexed
           (fn [idx param]
             [idx
              (comp-button
               {:text (str (name param) ": " (get state param)),
                :position [(* 120 idx) 0],
                :size [100 32],
                :fill (if (= param selected) (hslx 0 0 40)),
                :on {:click (fn [e d!] (d! cursor (assoc state :selected param)))},
                :on-keyboard (if (= param selected)
                  {:down (fn [e d!]
                     (case (:key e)
                       "ArrowUp" (d! cursor (update state selected inc))
                       "ArrowDown" (d! cursor (update state selected dec))
                       "`"
                         (d!
                          cursor
                          (assoc
                           state
                           selected
                           (or (js/parseFloat (js/prompt "get a number:")) 0)))
                       (js/console.warn "Unknown" e)))})})]))))
    (comp-button
     {:text "Random",
      :position [580 0],
      :on-click (fn [e d!]
        (d! cursor {:m (rand-int 40), :n (rand-int 40), :step 500, :unit 0.01}))}))))

(def initial-state {:step 1000, :unit 0.01, :m 13, :n 3, :selected :step})

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
    (comp-oscillo-control cursor state))))
