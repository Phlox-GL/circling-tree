
(ns app.comp.geocentric-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.util :refer [rand-point rand-color add-path]]
            [app.comp.button :refer [comp-button]]
            [phlox.comp.slider :refer [comp-slider]]))

(defcomp
 comp-geocentric-control
 (cursor state states)
 (container
  {:position [0 -20]}
  (create-list
   :container
   {}
   (->> [:r2 :v2 :r3 :v3 :steps :step]
        (map-indexed
         (fn [idx param]
           [idx
            (comp-slider
             (conj cursor param)
             (get states param)
             {:title (name param),
              :position [(* idx 140) 0],
              :value (get state param),
              :unit (case param :step 0.001 :steps 10 1),
              :on-change (fn [value d!]
                (d!
                 cursor
                 (assoc
                  state
                  param
                  (case param
                    :r2 (max 1 (js/Math.round value))
                    :v2 (max 1 (js/Math.round value))
                    :r3 (max 1 (js/Math.round value))
                    :v3 (max 1 (js/Math.round value))
                    :steps (js/Math.round value)
                    value))))})]))))
  (comp-button
   {:text "Random",
    :position [580 40],
    :on-click (fn [e d!]
      (d!
       cursor
       {:r2 (rand-int 200),
        :v2 (rand 3),
        :r3 (rand-int 200),
        :v3 (rand 3),
        :steps 4000,
        :step 0.1}))})))

(def initial-state
  {:r2 100, :r3 16, :v2 30, :v3 260, :steps 2000, :step 0.002, :selected :r2})

(defcomp
 comp-geocentric-demo
 (cursor states)
 (let [state (or (:data states) initial-state)]
   (container
    {}
    (graphics
     {:position [400 360],
      :ops (let [steps (:steps state)
                 step (:step state)
                 r2 (:r2 state)
                 r3 (:r3 state)
                 trail (->> (range steps)
                            (map
                             (fn [idx]
                               (let [t (* idx step)]
                                 (add-path
                                  (add-path
                                   [(* 200 (js/Math.cos t)) (* 200 (js/Math.sin t))]
                                   [(* r2 (js/Math.cos (* t (:v2 state))))
                                    (* r2 (js/Math.sin (* t (:v2 state))))])
                                  [(* r3 (js/Math.cos (* t (:v3 state))))
                                   (* r3 (js/Math.sin (* t (:v3 state))))])))))]
        (concat
         [(g :move-to (first trail))
          (g :line-style {:color (hslx 0 80 80), :width 2, :alpha 1})]
         (->> trail rest (map (fn [point] [:line-to point])))))})
    (comp-geocentric-control cursor state states))))

(defn get-unit [param] (case param :r2 1 :r3 0.5 :v2 0.2 :v3 0.2 :steps 100 :step 0.001 1))
