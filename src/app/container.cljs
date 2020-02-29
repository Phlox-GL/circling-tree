
(ns app.container
  (:require [phlox.core
             :refer
             [defcomp hslx rect circle text container graphics create-list hslx]]
            [app.comp.sun-demo :refer [comp-sun-demo]]
            [app.comp.circle-demo :refer [comp-circle-demo]]
            [app.comp.tree-demo :refer [comp-tree-demo]]
            [app.comp.walking-demo :refer [comp-walking-demo]]
            [app.comp.grow-demo :refer [comp-grow-demo]]
            [app.comp.street-demo :refer [comp-street-demo]]
            [app.comp.rotate-demo :refer [comp-rotate-demo]]
            [app.comp.rects-demo :refer [comp-rects-demo]]
            [app.comp.chars-demo :refer [comp-chars-demo]]
            [app.comp.bezier-demo :refer [comp-bezier-demo]]
            [app.comp.cycloid-demo :refer [comp-cycloid-demo]]
            [app.comp.chord-demo :refer [comp-chord-demo]]
            [app.comp.oscillo-demo :refer [comp-oscillo-demo]]
            [app.style :as style]
            [clojure.string :as string]))

(defn cap-name [x] (str (string/upper-case (first x)) (subs x 1)))

(defcomp
 comp-tab
 (title tab idx selected?)
 (container
  {:position [0 (* 40 idx)]}
  (rect
   {:position [0 0],
    :size [120 32],
    :fill (hslx 200 60 (if selected? 30 14)),
    :on {:click (fn [e d!] (d! :tab tab))}})
  (text
   {:text title,
    :position [20 3],
    :style {:fill (hslx 0 0 100), :font-size 20, :font-family style/font-fancy}})))

(def tabs
  [:sun :circle :tree :walking :grow :street :rotate :rects :bezier :cycloid :chord :oscillo])

(defcomp
 comp-container
 (store)
 (let [tab (:tab store), states (:states store), touch-key (:touch-key store)]
   (container
    {}
    (create-list
     :container
     {:position [60 80]}
     (->> tabs
          (map-indexed
           (fn [idx item] [idx (comp-tab (cap-name (name item)) item idx (= tab item))]))))
    (container
     {:position [280 80]}
     (case tab
       :home (comp-sun-demo touch-key)
       nil (comp-sun-demo touch-key)
       :circle (comp-circle-demo touch-key)
       :tree (comp-tree-demo touch-key)
       :walking (comp-walking-demo touch-key)
       :grow (comp-grow-demo touch-key)
       :street (comp-street-demo touch-key)
       :rotate (comp-rotate-demo touch-key)
       :rects (comp-rects-demo touch-key)
       :chars (comp-chars-demo touch-key)
       :bezier (comp-bezier-demo touch-key)
       :cycloid (comp-cycloid-demo [:cycloid] (get states :cycloid))
       :chord (comp-chord-demo touch-key)
       :oscillo (comp-oscillo-demo [:oscillo] (get states :oscillo))
       (text {:text (str "Unknown " tab), :style {:fill (hslx 0 0 100)}, :position [0 0]}))))))
