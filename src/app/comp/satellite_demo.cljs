
(ns app.comp.satellite-demo
  (:require [phlox.core
             :refer
             [defcomp >> hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util :refer [rand-point]]
            [phlox.comp.slider :refer [comp-slider]]
            [phlox.comp.button :refer [comp-button]]))

(defcomp
 comp-number-controls
 (state states)
 (let [cursor (:cursor states)
       selected (get state :selected)
       segment (get-in state [:segments selected])]
   (container
    {}
    (comp-slider
     (>> states :unit)
     {:value (:unit state),
      :unit 0.1,
      :min 0,
      :title "unit",
      :on-change (fn [result d!] (d! cursor (assoc state :unit result)))})
    (comp-slider
     (>> states :selected)
     {:value (:selected state),
      :position [140 0],
      :unit 0.1,
      :round? true,
      :min 0,
      :max (dec (count (:segments state))),
      :title "selected",
      :on-change (fn [result d!] (d! cursor (assoc state :selected result)))})
    (comp-slider
     (>> states :from)
     {:value (get-in state [:segments (:selected state) 0]),
      :position [280 0],
      :unit 1,
      :round? true,
      :title "from angle",
      :on-change (fn [result d!]
        (d! cursor (assoc-in state [:segments (:selected state) 0] result)))})
    (comp-slider
     (>> states :to)
     {:value (get-in state [:segments (:selected state) 1]),
      :position [420 0],
      :unit 1,
      :round? true,
      :min 0,
      :max 360,
      :title "range",
      :on-change (fn [result d!]
        (d! cursor (assoc-in state [:segments (:selected state) 1] result)))})
    (comp-button
     {:text "Add",
      :position [600 0],
      :on {:pointertap (fn [e d!]
             (d!
              cursor
              (-> state
                  (update :segments (fn [xs] (conj xs [(rand-int 360) (rand-int 360)])))
                  (assoc :selected (count (:segments state))))))}})
    (comp-button
     {:text "Remove",
      :position [660 0],
      :on {:pointertap (fn [e d!]
             (d!
              cursor
              (-> state
                  (update :segments (fn [xs] (if (< (count xs) 2) xs (pop xs))))
                  (assoc :selected 0))))}}))))

(defcomp
 comp-satellite-demo
 (states)
 (let [cursor (:cursor states)
       state (or (:data states)
                 {:unit 20, :segments [[0 100] [50 200] [100 180]], :selected 0})
       ratio (* js/Math.PI (/ 1 180))
       rad (fn [x] (* x ratio))]
   (container
    {}
    (comp-number-controls state states)
    (create-list
     :container
     {:position [400 400]}
     (->> (:segments state)
          (map-indexed
           (fn [idx segment]
             [idx
              (let [r (+ 10 (* idx (:unit state)))]
                (graphics
                 {:ops [(g
                         :line-style
                         {:color (if (= idx (:selected state))
                            (hslx 0 0 100)
                            (hslx 20 80 70)),
                          :width (if (= idx (:selected state)) 2 2),
                          :alpha 1})
                        (comment g :begin-fill {:color (hslx 20 80 70)})
                        (g
                         :arc
                         {:center (let [th (first segment)]
                            [(* r (js/Math.cos (rad th))) (* r (js/Math.sin (rad th)))]),
                          :radius 4,
                          :angle [0 360]})
                        (g
                         :arc
                         {:center [0 0],
                          :radius r,
                          :angle (let [segment (get-in state [:segments idx])]
                            [(first segment) (+ (first segment) (peek segment))])})
                        (g
                         :arc
                         {:center (let [th (+ (first segment) (peek segment))]
                            [(* r (js/Math.cos (rad th))) (* r (js/Math.sin (rad th)))]),
                          :radius 4,
                          :angle [0 360]})
                        (g :end-fill nil)]}))])))))))
