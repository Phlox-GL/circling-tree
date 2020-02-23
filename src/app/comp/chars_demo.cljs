
(ns app.comp.chars-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util :refer [rand-point]]
            [app.style :as style]))

(def curve-strokes
  [[(g :move-to [0 0]) (g :arc {:center [0 10], :radius 10, :angle [(* -0.5 js/Math.PI) 0]})]
   [(g :move-to [10 0]) (g :arc {:center [0 0], :radius 10, :angle [0 (* 0.5 js/Math.PI)]})]
   [(g :move-to [10 10])
    (g :arc {:center [10 0], :radius 10, :angle [(* 0.5 js/Math.PI) js/Math.PI]})]
   [(g :move-to [0 10])
    (g :arc {:center [10 10], :radius 10, :angle [js/Math.PI (* 1.5 js/Math.PI)]})]])

(def dot-strokes
  [[(g :move-to [4 5])
    (g :arc {:center [5 5], :radius 1, :angle [(- 0 js/Math.PI) js/Math.PI]})
    (g :close-path nil)]
   [(g :move-to [0 5])
    (g :arc {:center [5 5], :radius 4, :angle [(- 0 js/Math.PI) js/Math.PI]})
    (g :close-path nil)]])

(def slash-strokes
  [[(g :move-to [0 0]) (g :line-to [10 10])] [(g :move-to [10 0]) (g :line-to [0 10])] []])

(def straight-strokes
  [[(g :move-to [5 0]) (g :line-to [5 10])] [(g :move-to [0 5]) (g :line-to [10 5])] []])

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
              (rand-nth
               [(concat (rand-nth straight-strokes) (rand-nth straight-strokes))
                (concat (rand-nth slash-strokes) (rand-nth slash-strokes))
                (rand-nth dot-strokes)
                []])
            3 (rand-nth [(rand-nth curve-strokes) (rand-nth dot-strokes) []])
            4
              (rand-nth
               [(concat (rand-nth straight-strokes) (rand-nth straight-strokes))
                (concat (rand-nth curve-strokes) (rand-nth curve-strokes))
                (rand-nth dot-strokes)
                []])
            5
              (rand-nth
               [(concat (rand-nth slash-strokes) (rand-nth slash-strokes))
                (rand-nth curve-strokes)
                []])
            (rand-nth
             [(concat (rand-nth straight-strokes) (rand-nth straight-strokes))
              (rand-nth curve-strokes)
              []]))))}))

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
                     (comp-char touch-key (rand-int 6)))])))))))
  (comp-reset [-40 40])))
