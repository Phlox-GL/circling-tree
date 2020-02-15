
(ns app.container
  (:require [phlox.core
             :refer
             [defcomp hslx rect circle text container graphics create-list hslx]]))

(defn generate-circle-ops [idx]
  (loop [angle 0, acc []]
    (if (> angle (+ js/Math.PI -0.3 (* 1.4 (js/Math.random))))
      acc
      (let [ratio (/ 1 (inc idx))
            a1 (+ angle (* 0.4 ratio))
            a2 (+ a1 (* 6 ratio (js/Math.random)))]
        (recur
         (+ a2 (* 0.2 ratio))
         (conj
          acc
          [:line-style {:color (* (js/Math.random) (hslx 0 0 100)), :width 3, :alpha 0}]
          [:arc
           {:center [0 0], :radius (* 8 idx), :angle [angle a1], :anticlockwise? false}]
          [:line-style {:color (* (js/Math.random) (hslx 0 0 100)), :width 4, :alpha 1}]
          [:arc {:center [0 0], :radius (* 8 idx), :angle [a1 a2], :anticlockwise? false}]))))))

(defcomp
 comp-circle-demo
 (touch-key)
 (container
  {:position [0 140]}
  (container
   {:position [-200 100]}
   (rect
    {:position [0 0],
     :size [80 40],
     :fill (hslx 0 0 30),
     :on {:click (fn [e d!] (d! :touch nil))}})
   (text
    {:text "Reset",
     :position [8 8],
     :style {:fill (hslx 0 0 90), :font-family "Josefin Sans", :font-size 20}}))
  (create-list
   :container
   {}
   (->> (range 60)
        (map
         (fn [idx] [idx (graphics {:position [500 0], :ops (generate-circle-ops idx)})]))))))

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
       :circle (comp-circle-demo touch-key)
       (text {:text (str "Unknown " tab), :position [0 0]}))))))
