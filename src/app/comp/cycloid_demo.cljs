
(ns app.comp.cycloid-demo
  (:require [phlox.core
             :refer
             [defcomp >> hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util :refer [rand-point add-path subtract-path multiply-path]]
            [app.comp.button :refer [comp-button]]
            [phlox.comp.slider :refer [comp-slider]]
            [phlox.comp.switch :refer [comp-switch]]))

(defn get-round? [param]
  (case param :r1 true :r2 true :r3 true :r4 true :r5 true :steps true (do false)))

(defn get-unit [param]
  (case param :r1 0.2 :r2 0.1 :r3 0.04 :r4 0.04 :r5 0.04 :steps 20 :v 0.001 1))

(defn round-value [v param] (case param :steps (js/Math.max 0 (js/Math.round v)) v))

(defcomp
 comp-numbers-control
 (state states)
 (let [cursor (:cursor states)
       params [:r1 :r2 :r3 :r4 :r5 :steps :v]
       round? (:round? state)
       rand-value (fn [] (if round? (- (rand-int 300) 100) (- (rand 300) 100)))]
   (container
    {:position [-40 -80]}
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
                :position [(* idx 130) 30],
                :unit (get-unit param),
                :round? (if round? (get-round? param) false),
                :title (name param),
                :on-change (fn [v d!] (d! cursor (assoc state param (round-value v param))))})]))))
    (comp-switch
     {:value round?,
      :title "Round value?",
      :position [0 100],
      :on-change (fn [e d!] (d! cursor (update state :round? not)))})
    (comp-button
     {:text "rand2",
      :position [100 80],
      :on-click (fn [e d!]
        (d! cursor (merge state {:r1 (rand-value), :r2 (rand-value), :r3 0, :r4 0, :r5 0})))})
    (comp-button
     {:text "rand3",
      :position [240 80],
      :on-click (fn [e d!]
        (d!
         cursor
         (merge state {:r1 (rand-value), :r2 (rand-value), :r3 (rand-value), :r4 0, :r5 0})))})
    (comp-button
     {:text "rand4",
      :position [380 80],
      :on-click (fn [e d!]
        (d!
         cursor
         (merge
          state
          {:r1 (rand-value), :r2 (rand-value), :r3 (rand-value), :r4 (rand-value), :r5 0})))})
    (comp-button
     {:text "rand5",
      :position [520 80],
      :on-click (fn [e d!]
        (d!
         cursor
         (merge
          state
          {:r1 (rand-value),
           :r2 (rand-value),
           :r3 (rand-value),
           :r4 (rand-value),
           :r5 (rand-value)})))}))))

(defn polar-point [r theta] [(* r (js/Math.cos theta)) (* r (js/Math.sin theta))])

(defcomp
 comp-cycloid-demo
 (states)
 (let [cursor (:cursor states)
       state (or (:data states)
                 {:r1 312,
                  :r2 80,
                  :r3 96,
                  :r4 20,
                  :r5 8,
                  :steps 2000,
                  :v 0.11,
                  :round? true})]
   (container
    {}
    (comp-numbers-control state states)
    (graphics
     {:position [400 400],
      :ops (let [r1 (:r1 state)
                 r2 (:r2 state)
                 r3 (:r3 state)
                 r4 (:r4 state)
                 r5 (:r5 state)
                 trail (->> (range (:steps state))
                            (map
                             (fn [idx]
                               (let [t (* idx (:v state))
                                     dr (- r1 r2)
                                     dr2 (- r2 r3)
                                     dr3 (- r3 r4)
                                     dr4 (- r4 r5)
                                     t2 (unchecked-negate (/ (* t r1) r2))
                                     t3 (unchecked-negate (/ (* t2 r2) r3))
                                     t4 (unchecked-negate (/ (* t3 r3) r4))
                                     t5 (unchecked-negate (/ (* t4 r4) r5))]
                                 (-> (polar-point dr t)
                                     (add-path (if (zero? r2) [0 0] (polar-point dr2 t2)))
                                     (add-path (if (zero? r3) [0 0] (polar-point dr3 t3)))
                                     (add-path (if (zero? r4) [0 0] (polar-point dr4 t4)))
                                     (add-path (if (zero? r5) [0 0] (polar-point r5 t5))))))))]
        (concat
         [(g :line-style {:color (hslx 0 80 70), :width 2, :alpha 0.7})
          (g :move-to (or (first trail) [0 0]))]
         (->> trail rest (mapcat (fn [p] [(g :line-to p)])))))}))))
