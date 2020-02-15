
(ns app.container
  (:require [phlox.core
             :refer
             [defcomp hslx rect circle text container graphics create-list hslx]]))

(defcomp comp-circle-demo () (container {}))

(defn generate-line-ops []
  (let [x0 2, ops [[:move-to [(+ x0 (* 400 (js/Math.random))) 0]]]]
    (loop [acc ops, x x0]
      (if (> x 300)
        acc
        (let [x1 (+ x (* 80 (js/Math.random))), x2 (+ x1 (+ 4 (* 8 (js/Math.random))))]
          (recur
           (conj
            acc
            [:line-style
             {:color (* (js/Math.random) (hslx 0 0 100)),
              :width (if (< x2 160) 2 3),
              :alpha (if (< x2 80) 0.2 0.9)}]
            [:line-to [x1 0]]
            [:move-to [x2 0]])
           x2))))))

(defcomp
 comp-sun-demo
 (touch-key)
 (container
  {:position [200 200]}
  (container
   {:position [-300 0]}
   (rect
    {:position [0 0],
     :size [80 40],
     :fill (hslx 0 0 40),
     :on {:click (fn [e d!] (d! :touch nil))}})
   (text
    {:text "Reset",
     :position [8 4],
     :style {:font-family "Josefin Sans", :fill (hslx 0 0 100)}}))
  (create-list
   :container
   {:position [400 40]}
   (->> (range 200)
        (map
         (fn [x]
           [x
            (graphics
             {:position [0 0], :rotation (* 0.01 js/Math.PI x), :ops (generate-line-ops)})]))))))

(defcomp
 comp-tab
 (title tab idx selected?)
 (container
  {:position [0 (* 60 idx)]}
  (rect
   {:position [0 0],
    :size [120 40],
    :fill (hslx 200 60 30),
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
     (comp-tab "Circle" :circle 1 (= tab :circle)))
    (container
     {:position [280 80]}
     (case tab
       :home (comp-sun-demo touch-key)
       nil (comp-sun-demo touch-key)
       :circle (comp-circle-demo)
       (text {:text (str "Unknown " tab), :position [0 0]}))))))
