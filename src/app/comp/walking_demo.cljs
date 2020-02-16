
(ns app.comp.walking-demo
  (:require [phlox.core
             :refer
             [defcomp hslx rect circle text container graphics create-list hslx]]
            [app.util :refer [add-path multiply-path]]
            [app.comp.reset :refer [comp-reset]]))

(defonce *grid (atom {}))

(defn expand-directions [base]
  [(add-path base [0 -1]) (add-path base [0 1]) (add-path base [1 0]) (add-path base [-1 0])])

(defn pick-one [xs] (nth xs (rand-int (count xs))))

(defn iterate-trails [trails]
  (->> trails
       (map
        (fn [trail]
          (let [pick-next (fn [base]
                            (let [directions (expand-directions base)
                                  available (->> directions
                                                 (remove (fn [x] (get @*grid x))))]
                              (if (not (empty? available))
                                (let [picked (pick-one available)]
                                  (swap! *grid assoc picked true)
                                  [picked])
                                [])))]
            (let [tail-next (pick-next (peek trail)), head-next (pick-next (first trail))]
              (cond
                (and (empty? head-next) (empty? tail-next)) trail
                (empty? head-next) (conj trail (first tail-next))
                (empty? tail-next) (vec (concat head-next trail))
                :else (vec (concat head-next trail tail-next)))))))))

(defn rand-point [n] [(rand-int n) (rand-int n)])

(defn generate-trails []
  (reset! *grid {})
  (let [trails (->> (range 280) (map (fn [x] [(rand-point 80)])) (distinct) (vec))]
    (doseq [[point] trails] (swap! *grid assoc point true))
    (loop [idx 120, acc trails] (if (zero? idx) acc (recur (dec idx) (iterate-trails acc))))))

(defn get-trail-ops [trail]
  (let [zoom-in [6 0]]
    (vec
     (concat
      [[:move-to (multiply-path (first trail) zoom-in)]
       [:line-style {:color (rand-int (hslx 0 0 90)), :width 2, :alpha 1}]]
      (->> trail rest (map (fn [stop] [:line-to (multiply-path stop zoom-in)])))))))

(defcomp
 comp-walking-demo
 (touch-key)
 (let [trails (generate-trails)]
   (container
    {}
    (create-list
     :container
     {:position [200 0]}
     (->> trails
          (map-indexed
           (fn [idx trail] [idx (graphics {:position [0 0], :ops (get-trail-ops trail)})]))))
    (comp-reset [0 0]))))
