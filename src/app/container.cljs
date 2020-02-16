
(ns app.container
  (:require [phlox.core
             :refer
             [defcomp hslx rect circle text container graphics create-list hslx]]
            [app.comp.sun-demo :refer [comp-sun-demo]]
            [app.comp.circle-demo :refer [comp-circle-demo]]
            [app.comp.tree-demo :refer [comp-tree-demo]]
            [app.comp.walking-demo :refer [comp-walking-demo]]
            [app.comp.grow-demo :refer [comp-grow-demo]]))

(defcomp
 comp-tab
 (title tab idx selected?)
 (container
  {:position [0 (* 60 idx)]}
  (rect
   {:position [0 0],
    :size [120 40],
    :fill (hslx 200 60 (if selected? 30 18)),
    :on {:click (fn [e d!] (d! :tab tab))}})
  (text
   {:text title,
    :position [20 3],
    :style {:fill (hslx 0 0 100), :font-family "Josefin Sans"}})))

(defcomp
 comp-container
 (store)
 (let [tab (:tab store), touch-key (:touch-key store)]
   (container
    {}
    (container
     {:position [60 80]}
     (comp-tab "Sun" :home 0 (= tab :home))
     (comp-tab "Circle" :circle 1 (= tab :circle))
     (comp-tab "Tree" :tree 2 (= tab :tree))
     (comp-tab "Walking" :walking 3 (= tab :walking))
     (comp-tab "Grow" :grow 4 (= tab :grow))
     (comp-tab "Street" :street 5 (= tab :street)))
    (container
     {:position [280 80]}
     (case tab
       :home (comp-sun-demo touch-key)
       nil (comp-sun-demo touch-key)
       :circle (comp-circle-demo touch-key)
       :tree (comp-tree-demo touch-key)
       :walking (comp-walking-demo touch-key)
       :grow (comp-grow-demo touch-key)
       (text {:text (str "Unknown " tab), :position [0 0]}))))))
