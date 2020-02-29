
(ns app.comp.button
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.util :refer [rand-point]]))

(defcomp
 comp-button
 (props)
 (let [position (or (:position props) [0 0])
       size (or (:size props) [120 32])
       button-text (or (:text props) "BUTTON")
       fill (or (:fill props) (hslx 0 0 20))
       on-click (:on-click props)]
   (container
    {:position position}
    (rect {:position [0 0], :size size, :fill fill, :on {:click on-click}})
    (text
     {:position [4 8],
      :text button-text,
      :style {:font-family "Josefin Sans, sans-serif", :font-size 16, :fill (hslx 0 0 100)}}))))
