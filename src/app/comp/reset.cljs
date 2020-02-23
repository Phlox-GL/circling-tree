
(ns app.comp.reset
  (:require [phlox.core
             :refer
             [defcomp hslx rect circle text container graphics create-list hslx]]
            [app.style :as style]))

(defcomp
 comp-reset
 (position)
 (container
  {:position position}
  (rect
   {:position [0 0],
    :size [80 40],
    :fill (hslx 0 0 40),
    :on {:click (fn [e d!] (d! :touch nil))}})
  (text
   {:text "Refresh",
    :position [8 6],
    :style {:font-family style/font-fancy, :fill (hslx 0 0 100), :font-size 20}})))
