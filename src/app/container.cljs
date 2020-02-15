
(ns app.container
  (:require [phlox.core
             :refer
             [defcomp hslx rect circle text container graphics create-list hslx]]))

(defcomp comp-circle-demo () (container {}))

(defcomp comp-sun-demo () (rect {:position [0 0], :size [40 40], :fill (hslx 0 0 90)}))

(defcomp
 comp-tab
 (title tab idx selected?)
 (container
  {:position [0 (* 60 idx)]}
  (rect
   {:position [0 0],
    :size [160 40],
    :fill (hslx 200 60 80),
    :on {:click (fn [e d!] (d! :tab tab))}})
  (text {:text title, :position [40 8], :style {:fill (hslx 0 0 100)}})))

(defcomp
 comp-container
 (store)
 (let [tab (:tab store)]
   (container
    {}
    (container
     {:position [60 80]}
     (comp-tab "Home" :home 0 (= tab :home))
     (comp-tab "Circle" :circle 1 (= tab :circle)))
    (container
     {:position [280 80]}
     (case tab
       :home (comp-sun-demo)
       nil (comp-sun-demo)
       :circle (comp-circle-demo)
       (text {:text (str "Unknown " tab), :position [0 0]}))))))
