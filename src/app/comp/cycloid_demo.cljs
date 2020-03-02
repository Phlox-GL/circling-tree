
(ns app.comp.cycloid-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util :refer [rand-point add-path subtract-path multiply-path]]
            [app.comp.button :refer [comp-button]]
            [phlox.comp.slider :refer [comp-slider]]))

(defn get-unit [param]
  (case param :r1 0.4 :r2 0.2 :r3 0.08 :tt1 0.01 :tt2 0.01 :steps 20 :v 0.004 1))

(defn round-value [v param] (max 0 (case param :steps (js/Math.round v) v)))

(defcomp
 comp-numbers-control
 (cursor state states)
 (let [params [:r1 :r2 :r3 :steps :v :tt1 :tt2]]
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
               (conj cursor idx)
               (get states idx)
               {:value (get state param),
                :position [(* idx 140) 30],
                :unit (get-unit param),
                :title (name param),
                :on-change (fn [v d!] (d! cursor (assoc state param (round-value v param))))})])))))))

(defcomp
 comp-cycloid-demo
 (cursor states)
 (let [state (or (:data states)
                 {:r1 312, :r2 80, :r3 96, :tt1 0, :tt2 0, :steps 2000, :v 0.11})]
   (container
    {}
    (graphics
     {:position [400 400],
      :ops (let [r1 (:r1 state)
                 r2 (:r2 state)
                 r3 (:r3 state)
                 tt1 (:tt1 state)
                 tt2 (:tt2 state)
                 trail (->> (range (:steps state))
                            (map
                             (fn [idx]
                               (let [t (* idx (:v state))
                                     dr (- r1 r2)
                                     dr2 (- r2 r3)
                                     t2 (+ tt1 (unchecked-negate (/ (* t r1) r2)))
                                     t3 (+ tt2 (unchecked-negate (/ (* t2 r2) r3)))]
                                 (add-path
                                  (add-path
                                   [(* dr (js/Math.cos t)) (* dr (js/Math.sin t))]
                                   [(* dr2 (js/Math.cos t2)) (* dr2 (js/Math.sin t2))])
                                  [(* r3 (js/Math.cos t3)) (* r3 (js/Math.sin t3))])))))]
        (vec
         (concat
          [(g :line-style {:color (hslx 0 80 70), :width 1, :alpha 0.7})
           (g :move-to (first trail))]
          (->> trail rest (mapcat (fn [p] [(g :line-to p)]))))))})
    (comp-numbers-control cursor state states))))
