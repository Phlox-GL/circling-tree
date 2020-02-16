
(ns app.comp.grow-demo
  (:require [phlox.core
             :refer
             [defcomp g hslx rect circle text container graphics create-list hslx]]
            [app.util :refer [add-path multiply-path]]
            [app.comp.reset :refer [comp-reset]]
            [clojure.core.rrb-vector :refer [catvec]]
            ["shortid" :as shortid]))

(defonce *grid (atom {}))

(defn expand-directions [base]
  [(add-path base [0 -1]) (add-path base [0 1]) (add-path base [1 0]) (add-path base [-1 0])])

(defn pick-many [xs] (vec xs))

(defn iterate-trails [points]
  (let [result (->> points
                    (map
                     (fn [[k base]]
                       (let [directions (expand-directions base)
                             available (->> directions
                                            (remove (fn [x] (get @*grid x)))
                                            (filter (fn [x] (> (rand) 0.5))))]
                         (let [picked (pick-many available)]
                           (doseq [x picked] (swap! *grid assoc x true))
                           [(->> picked (map (fn [x] [k x])))
                            (->> picked (map (fn [x] [k base x])))])))))]
    [(->> (concat points (mapcat first result))
          (remove
           (fn [[k point]]
             (let [directions (expand-directions point)
                   available (->> directions (remove (fn [x] (get @*grid x))))]
               (empty? available)))))
     (mapcat last result)]))

(defn rand-point [n]
  [(- (js/Math.round (* 0.2 n)) (rand-int n)) (- (js/Math.round (* 0.2 n)) (rand-int n))])

(defn generate-trails []
  (reset! *grid {})
  (let [trails (->> (range 20) (map (fn [x] (rand-point 60))) (distinct) (vec))]
    (doseq [point trails] (swap! *grid assoc point true))
    (loop [idx 60, points-with-keys (map (fn [x] [(shortid/generate) x]) trails), acc []]
      (if (zero? idx)
        (do
         (->> acc
              (group-by first)
              (vals)
              (map (fn [x] (->> x (map (fn [y] (subvec y 1))))))))
        (let [[new-points-keys pieces] (iterate-trails points-with-keys)]
          (recur (dec idx) new-points-keys (concat acc pieces)))))))

(defn get-trail-ops [trail]
  (let [zoom-in [6 0]]
    (vec
     (concat
      [(g :line-style {:color (rand-int (hslx 0 0 90)), :width 2, :alpha 1})]
      (->> trail
           rest
           (mapcat
            (fn [stop]
              [(g :move-to (multiply-path (first stop) zoom-in))
               (g :line-to (multiply-path (last stop) zoom-in))])))))))

(defcomp
 comp-grow-demo
 (touch-key)
 (let [trails (generate-trails)]
   (container
    {}
    (create-list
     :container
     {:position [540 400]}
     (->> trails
          (map-indexed
           (fn [idx trail] [idx (graphics {:position [0 0], :ops (get-trail-ops trail)})]))))
    (comp-reset [0 0]))))
