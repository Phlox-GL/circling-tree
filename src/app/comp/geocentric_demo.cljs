
(ns app.comp.geocentric-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.util :refer [rand-point rand-color add-path]]
            [app.comp.button :refer [comp-button]]))

(defn get-unit [param] (case param :r2 1 :r3 0.5 :v2 0.2 :v3 0.2 :steps 100 :step 0.001 1))

(defcomp
 comp-geocentric-control
 (cursor state)
 (let [selected (get state :selected)]
   (container
    {:position [0 -70]}
    (create-list
     :container
     {}
     (->> [:r2 :v2 :r3 :v3 :steps :step]
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
                       "ArrowUp"
                         (d! cursor (update state selected (fn [x] (+ x (get-unit param)))))
                       "ArrowDown"
                         (d! cursor (update state selected (fn [x] (- x (get-unit param)))))
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
      :position [580 40],
      :on-click (fn [e d!]
        (d!
         cursor
         {:r2 (rand-int 200),
          :v2 (rand 3),
          :r3 (rand-int 200),
          :v3 (rand 3),
          :steps 4000,
          :step 0.1}))}))))

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
    (comp-geocentric-control cursor state))))
