
(ns app.comp.chars-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util :refer [rand-point]]
            [app.style :as style]))

(def curve-strokes
  [[(g :move-to [0 0]) (g :quadratic-to {:p1 [10 0], :to-p [10 10]})]
   [(g :move-to [10 0]) (g :quadratic-to {:p1 [10 10], :to-p [0 10]})]
   [(g :move-to [10 10]) (g :quadratic-to {:p1 [0 10], :to-p [0 0]})]
   [(g :move-to [0 10]) (g :quadratic-to {:p1 [0 0], :to-p [10 0]})]])

(def slash-strokes
  [[(g :move-to [0 0]) (g :line-to [10 10])] [(g :move-to [10 0]) (g :line-to [0 10])]])

(def straight-strokes
  [[(g :move-to [5 0]) (g :line-to [5 10])] [(g :move-to [0 5]) (g :line-to [10 5])]])

(defcomp
 comp-stroke
 (touch-key kind)
 (graphics
  {:position [0 0],
   :ops (vec
         (concat
          [(g :line-style {:color (hslx 0 0 100), :width 2, :alpha 1})]
          (comment
           rand-nth
           [(rand-nth curve-strokes) (rand-nth straight-strokes) (rand-nth slash-strokes)])
          (case kind
            0 (concat (rand-nth straight-strokes) (rand-nth straight-strokes))
            1 (concat (rand-nth slash-strokes) (rand-nth slash-strokes))
            2
              (case (rand-int 2)
                0 (concat (rand-nth straight-strokes) (rand-nth straight-strokes))
                1 (concat (rand-nth slash-strokes) (rand-nth slash-strokes)))
            3 (rand-nth curve-strokes)
            (case (rand-int 3)
              0 (concat (rand-nth straight-strokes) (rand-nth straight-strokes))
              1 (concat (rand-nth slash-strokes) (rand-nth slash-strokes))
              (rand-nth curve-strokes)))))}))

(defcomp
 comp-char
 (touch-key kind)
 (container
  {}
  (rect {:position [-3 -3], :size [46 46], :fill (hslx 240 60 70)})
  (create-list
   :container
   {}
   (->> (range 4)
        (mapcat
         (fn [y]
           (->> (range 4)
                (map
                 (fn [x]
                   [(str x "+" y)
                    (container {:position [(* x 10) (* y 10)]} (comp-stroke touch-key kind))])))))))))

(defcomp
 comp-chars-demo
 (touch-key)
 (container
  {}
  (create-list
   :container
   {:position [100 0]}
   (->> (range 10)
        (mapcat
         (fn [y]
           (->> (range 10)
                (map
                 (fn [x]
                   [(str x "+" y)
                    (container
                     {:position [(* x 50) (* y 50)]}
                     (comp-char touch-key (rand-int 5)))])))))))
  (comp-reset [-40 40])))
