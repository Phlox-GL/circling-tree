
(ns app.comp.reset
  (:require [phlox.core
             :refer
             [defcomp hslx rect circle text container graphics create-list hslx]]))

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
   {:text "Reset",
    :position [8 4],
    :style {:font-family "Josefin Sans", :fill (hslx 0 0 100)}})))
