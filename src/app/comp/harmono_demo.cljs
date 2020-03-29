
(ns app.comp.harmono-demo
  (:require [phlox.core
             :refer
             [defcomp >> hslx g rect circle text container graphics create-list hslx]]
            [app.util :refer [rand-point rand-color add-path multiply-path]]
            [phlox.comp.slider :refer [comp-slider]]
            [phlox.comp.drag-point :refer [comp-drag-point]]))

(defn gen-trail [controls steps base]
  (->> (range steps)
       (map
        (fn [idx]
          (let [t (* idx base)
                final-point (->> controls
                                 (map
                                  (fn [control]
                                    (multiply-path
                                     [(*
                                       (js/Math.sin
                                        (+ (* t (:frequency control)) (:phase control)))
                                       (js/Math.pow js/Math.E (* -1 (:damping control) t)))
                                      0]
                                     (:amplitude control))))
                                 (reduce add-path))]
            final-point)))))

(defn render-controls [cursor states state controls]
  (container
   {:position [0 -340]}
   (comp-slider
    (>> states :steps)
    {:position [0 0],
     :value (:steps state),
     :unit 10,
     :round? true,
     :min 0,
     :title "steps",
     :on-change (fn [v d!] (d! cursor (assoc state :steps v)))})
   (comp-slider
    (>> states :base)
    {:position [140 0],
     :value (:base state),
     :unit 0.001,
     :round? false,
     :min 0,
     :title "base",
     :on-change (fn [v d!] (d! cursor (assoc state :base v)))})
   (create-list
    :container
    {}
    (->> controls
         (map-indexed
          (fn [idx control]
            [idx
             (container
              {:position [(- (* idx 140) 600) 0]}
              (comp-slider
               (>> states (str "frequency:" idx))
               {:position [140 0],
                :value (:frequency control),
                :unit 0.1,
                :round? true,
                :min 0,
                :title "frequency",
                :on-change (fn [v d!]
                  (d! cursor (assoc-in state [:controls idx :frequency] v)))})
              (comp-slider
               (>> states (str "phase:" idx))
               {:position [140 50],
                :value (:phase control),
                :unit 0.1,
                :round? false,
                :min 0,
                :title "phase",
                :on-change (fn [v d!] (d! cursor (assoc-in state [:controls idx :phase] v)))})
              (comp-slider
               (>> states (str "damping:" idx))
               {:position [140 100],
                :value (:damping control),
                :unit 0.01,
                :round? false,
                :min 0,
                :title "damping",
                :on-change (fn [v d!]
                  (d! cursor (assoc-in state [:controls idx :damping] v)))}))]))))))

(defn render-points [cursor states state controls]
  (create-list
   :container
   {}
   (->> controls
        (map-indexed
         (fn [idx control]
           [idx
            (comp-drag-point
             (>> states (str "apmplitude:" idx))
             {:position (:amplitude control),
              :on-change (fn [v d!]
                (d! cursor (assoc-in state [:controls idx :amplitude] v)))})])))))

(defcomp
 comp-harmono-demo
 (states)
 (let [cursor (:cursor states)
       state (or (:data states)
                 {:controls (->> (range 3)
                                 (map
                                  (fn []
                                    {:amplitude (rand-point 40),
                                     :frequency (rand 10),
                                     :phase 6,
                                     :damping (rand 2)}))
                                 (vec)),
                  :steps 100,
                  :base 0.01})
       controls (:controls state)
       trail (gen-trail controls (:steps state) (:base state))]
   (container
    {:position [400 300]}
    (render-controls cursor states state controls)
    (container
     {}
     (graphics
      {:position [0 80],
       :ops (concat
             [(g :move-to (first trail))
              (g :line-style {:color (hslx 0 0 100), :width 1, :alpha 1})]
             (->> (rest trail) (map-indexed (fn [idx point] (g :line-to point)))))})
     (render-points cursor states state controls)))))
