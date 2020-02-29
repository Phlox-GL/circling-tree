
(ns app.comp.cycloid-demo
  (:require [phlox.core
             :refer
             [defcomp hslx g rect circle text container graphics create-list hslx]]
            [app.comp.reset :refer [comp-reset]]
            [app.util :refer [rand-point add-path subtract-path multiply-path]]
            [app.comp.button :refer [comp-button]]))

(defn get-unit [param] (case param :tt1 0.03 :tt2 0.03 1))

(defcomp
 comp-numbers-control
 (cursor state)
 (let [selected (:selected state), params [:r1 :r2 :r3 :tt1 :tt2]]
   (container
    {:position [0 -80]}
    (create-list
     :container
     {}
     (->> params
          (map-indexed
           (fn [idx param]
             [idx
              (container
               {:position [(* idx 100) 0]}
               (rect
                {:position [0 0],
                 :size [80 30],
                 :fill (if (= selected param) (hslx 0 0 40) (hslx 0 0 20)),
                 :on {:click (fn [e d!] (d! :states [cursor (assoc state :selected param)]))},
                 :on-keyboard (if (= param selected)
                   {:down (fn [e d!]
                      (case (:key e)
                        "ArrowUp"
                          (d!
                           cursor
                           (assoc state selected (+ (get state selected) (get-unit param))))
                        "ArrowDown"
                          (d!
                           cursor
                           (assoc state selected (- (get state selected) (get-unit param))))
                        "`"
                          (d!
                           cursor
                           (assoc
                            state
                            selected
                            (or (js/parseFloat (js/prompt "specify a number")) 0)))
                        (js/console.warn "not handled" e)))})})
               (text
                {:text (str (name param) ": " (get state param)),
                 :position [4 8],
                 :style {:fill (hslx 0 0 100), :font-size 13}}))]))))
    (comp-button
     {:text "Random",
      :position [580 0],
      :on-click (fn [e d!]
        (d!
         cursor
         {:r1 (rand-int 400),
          :r2 (rand-int 300),
          :r3 (rand-int 200),
          :tt1 (rand 4),
          :tt2 (rand 4)}))}))))

(defcomp
 comp-cycloid-demo
 (cursor states)
 (let [state (or (:data states) {:r1 312, :r2 80, :r3 96, :tt1 0, :tt2 0, :selected :r1})]
   (container
    {}
    (graphics
     {:position [400 400],
      :ops (let [r1 (:r1 state)
                 r2 (:r2 state)
                 r3 (:r3 state)
                 tt1 (:tt1 state)
                 tt2 (:tt2 state)
                 trail (->> (range 8000)
                            (map
                             (fn [idx]
                               (let [t (* idx 0.11)
                                     dr (- r1 r2)
                                     dr2 (- r2 r3)
                                     t2 (+ tt1 (unchecked-negate (/ (* t r1) r2)))
                                     t3 (+ tt2 (unchecked-negate (/ (* t2 r2) r3)))]
                                 (add-path
                                  (add-path
                                   [(* dr (js/Math.cos t)) (* dr (js/Math.sin t))]
                                   [(* dr2 (js/Math.cos t2)) (* dr2 (js/Math.sin t2))])
                                  [(* r3 (js/Math.cos t3)) (* r3 (js/Math.sin t3))])))))]
        (vec
         (concat
          [(g :line-style {:color (rand-int (hslx 0 0 100)), :width 1, :alpha 0.8})
           (g :move-to (first trail))]
          (->> trail rest (mapcat (fn [p] [(g :line-to p)]))))))})
    (comp-numbers-control cursor state))))
