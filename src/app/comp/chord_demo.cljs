
(ns app.comp.chord-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util :refer [rand-point rand-color]]))

(defcomp
 comp-chord-demo
 (touch-key)
 (container
  {}
  (graphics
   {:position [400 320],
    :ops (let [r 320, shares (+ 2 (rand-int 200))]
      (->> (range shares)
           shuffle
           (mapcat
            (fn [idx]
              (let [t (* 2 js/Math.PI idx (/ 1 shares))
                    t2 (rand (* 2 js/Math.PI))
                    color (hslx (* 180 t (/ 1 js/Math.PI)) 100 60)]
                [(g :move-to [(* r (js/Math.cos t)) (* r (js/Math.sin t))])
                 (g :line-style {:color color, :width 2, :alpha 0.8})
                 (g
                  :quadratic-to
                  {:p1 [0 0], :to-p [(* r (js/Math.cos t2)) (* r (js/Math.sin t2))]})
                 (g :line-style {:color color, :width 0, :alpha 0})
                 (g
                  :arc
                  {:center [0 0],
                   :radius r,
                   :angle [t2 t],
                   :anticlockwise? (< (js/Math.abs (- t t2)) js/Math.PI)})])))))})
  (comp-reset [-40 40])))
