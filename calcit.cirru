
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --full` first. Manual edits must follow format and schema conventions, then run `calcit edit format`.") (:package |app)
  :entries $ {}
    :default $ {} (:description |) (:init-fn 'app.main/main!) (:mode :native) (:reload-fn 'app.main/reload!)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/ |phlox/ |touch-control/
      :type-slots $ {}
  :files $ {}
    |app.comp.bezier-demo $ %{} 'FileEntry
      :defs $ {}
        |comp-bezier-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-bezier-demo (states)
              let
                  cursor $ option:unwrap-or (get states :cursor) nil
                  state $ or
                    option:unwrap-or (get states :data) nil
                    {}
                      :points $ [] ([] 40 100) ([] 200 100) ([] 200 400) ([] 40 400)
                      :n 80
                container ({})
                  graphics $ {}
                    :position $ [] 0 0
                    :ops $ let-sugar
                          [] p1 p2 q1 q2
                          option:unwrap-or (get state :points) nil
                        n $ option:unwrap-or (get state :n) nil
                      gen-trail p1 p2 q1 q2 n
                  create-list :container ({})
                    ->
                      option:unwrap-or (get state :points) nil
                      map-indexed $ fn (idx point)
                        [] idx $ comp-drag-point (>> states idx)
                          {} (:position point)
                            :on-change $ fn (value d!)
                              d! cursor $ assoc-in state ([] :points idx) value
                  comp-slider (>> states :n)
                    {} (:title |n)
                      :position $ [] 0 -40
                      :value $ option:unwrap-or (get state :n) nil
                      :unit 0.3
                      :round? true
                      :on-change $ fn (value d!)
                        d! cursor $ assoc state :n
                          js/Math.max 1 $ js/Math.round value
          :examples $ []
          :schema $ :: 'Dynamic
        |gen-trail $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn gen-trail (p1 p2 q1 q2 n)
              let
                  p-unit $ divide-x (subtract-path p2 p1) n
                  q-unit $ divide-x (subtract-path q1 q2) n
                ->
                  range $ inc n
                  mapcat $ fn (idx)
                    let
                        p3 $ add-path p1
                          multiply-path p-unit $ [] idx 0
                        q3 $ add-path q2
                          multiply-path q-unit $ [] idx 0
                        m-unit $ divide-x (subtract-path q3 p3) n
                        mp $ add-path p3
                          multiply-path m-unit $ [] idx 0
                      [] (g :move-to p3)
                        [] :line-style $ {}
                          :color $ hslx 200 100 70
                          :width 3
                          :alpha 0.3
                        g :line-to mp
                        [] :line-style $ {}
                          :color $ hslx 20 100 70
                          :width 3
                          :alpha 0.9
                        g :line-to q3
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.bezier-demo $ :require
            [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
            [] app.comp.reset :refer $ [] comp-reset
            [] app.util :refer $ [] rand-point add-path subtract-path divide-x multiply-path
            [] phlox.comp.drag-point :refer $ [] comp-drag-point
            [] phlox.comp.slider :refer $ [] comp-slider
    |app.comp.chars-demo $ %{} 'FileEntry
      :defs $ {}
        |comp-char $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-char (touch-key kind)
              container ({})
                rect $ {}
                  :position $ [] -3 -3
                  :size $ [] 46 46
                  :line-style $ {}
                    :color $ hslx 0 0 100
                    :alpha 0.4
                    :width 1
                create-list :container ({})
                  -> (range 4)
                    mapcat $ fn (y)
                      -> (range 4)
                        map $ fn (x)
                          [] (str x |+ y)
                            container
                              {} $ :position
                                [] (* x 10) (* y 10)
                              comp-stroke touch-key kind
          :examples $ []
          :schema $ :: 'Dynamic
        |comp-chars-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-chars-demo (touch-key)
              container ({})
                create-list :container
                  {} $ :position ([] 0 0)
                  -> (range 10)
                    mapcat $ fn (y)
                      -> (range 10)
                        map $ fn (x)
                          [] (str x |+ y)
                            container
                              {} $ :position
                                [] (* x 54) (* y 54)
                              comp-char touch-key $ rand-int 6
                comp-reset $ [] -140 40
          :examples $ []
          :schema $ :: 'Dynamic
        |comp-stroke $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-stroke (touch-key kind)
              graphics $ {}
                :position $ [] 0 0
                :ops $ concat
                  [] $ g :line-style
                    {}
                      :color $ hslx 0 0 100
                      :width 1
                      :alpha 1
                  ; rand-nth $ [] (rand-nth curve-strokes) (rand-nth straight-strokes) (rand-nth slash-strokes)
                  case kind
                    0 $ concat (rand-nth straight-strokes) (rand-nth straight-strokes)
                    1 $ concat (rand-nth slash-strokes) (rand-nth slash-strokes)
                    2 $ rand-nth
                      []
                        concat (rand-nth straight-strokes) (rand-nth straight-strokes)
                        concat (rand-nth slash-strokes) (rand-nth slash-strokes)
                        rand-nth dot-strokes
                        []
                    3 $ rand-nth
                      [] (rand-nth curve-strokes) (rand-nth dot-strokes) ([])
                    4 $ rand-nth
                      []
                        concat (rand-nth straight-strokes) (rand-nth straight-strokes)
                        concat (rand-nth curve-strokes) (rand-nth curve-strokes)
                        rand-nth dot-strokes
                        []
                    5 $ rand-nth
                      []
                        concat (rand-nth slash-strokes) (rand-nth slash-strokes)
                        rand-nth curve-strokes
                        []
                    rand-nth $ []
                      concat (rand-nth straight-strokes) (rand-nth straight-strokes)
                      rand-nth curve-strokes
                      []
          :examples $ []
          :schema $ :: 'Dynamic
        |curve-strokes $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def curve-strokes $ []
              []
                g :move-to $ [] 0 0
                g :arc $ {}
                  :center $ [] 0 10
                  :radius 10
                  :angle $ [] (* -0.5 phlox.math/ffi-pi) 0
              []
                g :move-to $ [] 10 0
                g :arc $ {}
                  :center $ [] 0 0
                  :radius 10
                  :angle $ [] 0 (* 0.5 phlox.math/ffi-pi)
              []
                g :move-to $ [] 10 10
                g :arc $ {}
                  :center $ [] 10 0
                  :radius 10
                  :angle $ [] (* 0.5 phlox.math/ffi-pi) js/Math.PI
              []
                g :move-to $ [] 0 10
                g :arc $ {}
                  :center $ [] 10 10
                  :radius 10
                  :angle $ [] js/Math.PI (* 1.5 phlox.math/ffi-pi)
          :examples $ []
          :schema $ :: 'Dynamic
        |dot-strokes $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def dot-strokes $ []
              []
                g :move-to $ [] 4 5
                g :arc $ {}
                  :center $ [] 5 5
                  :radius 1
                  :angle $ [] (- 0 phlox.math/ffi-pi) js/Math.PI
                g :close-path nil
              []
                g :move-to $ [] 0 5
                g :arc $ {}
                  :center $ [] 5 5
                  :radius 4
                  :angle $ [] (- 0 phlox.math/ffi-pi) js/Math.PI
                g :close-path nil
          :examples $ []
          :schema $ :: 'Dynamic
        |slash-strokes $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def slash-strokes $ []
              []
                g :move-to $ [] 0 0
                g :line-to $ [] 10 10
              []
                g :move-to $ [] 10 0
                g :line-to $ [] 0 10
              []
          :examples $ []
          :schema $ :: 'Dynamic
        |straight-strokes $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def straight-strokes $ []
              []
                g :move-to $ [] 5 0
                g :line-to $ [] 5 10
              []
                g :move-to $ [] 0 5
                g :line-to $ [] 10 5
              []
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.chars-demo $ :require
            [] phlox.core :refer $ [] defcomp hslx g rect circle text container graphics create-list hslx
            [] app.comp.reset :refer $ [] comp-reset
            [] app.util :refer $ [] rand-point rand-nth
            [] app.style :as style
            |@calcit/std :refer $ rand rand-int
    |app.comp.chord-demo $ %{} 'FileEntry
      :defs $ {}
        |comp-chord-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-chord-demo (states)
              let
                  cursor $ option:unwrap-or (get states :cursor) nil
                  state $ or
                    option:unwrap-or (get states :data) nil
                    {} $ :size 20
                container ({})
                  graphics $ {}
                    :position $ [] 200 320
                    :ops $ generate-ops
                      option:unwrap-or (get state :size) nil
                  comp-slider (>> states :size)
                    {}
                      :value $ option:unwrap-or (get state :size) nil
                      :title |Size
                      :unit 0.1
                      :round? true
                      :on-change $ fn (n d!)
                        d! cursor $ assoc state :size
                          js/Math.min 300 $ js/Math.max (js/Math.round n) 4
          :examples $ []
          :schema $ :: 'Dynamic
        |generate-ops $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn generate-ops (size)
              let
                  r 320
                  shares $ + 2 size
                -> (range shares) shuffle $ mapcat
                  fn (idx)
                    let
                        t $ * 2 phlox.math/ffi-pi idx (/ 1 shares)
                        t2 $ rand (* 2 phlox.math/ffi-pi)
                        color $ hslx
                          * 180 t $ / 1 phlox.math/ffi-pi
                          , 100 60
                      []
                        g :move-to $ []
                          * r $ phlox.core/ffi-cos t
                          * r $ phlox.core/ffi-sin t
                        g :line-style $ {} (:color color) (:width 2) (:alpha 0.8)
                        g :quadratic-to $ {}
                          :p1 $ [] 0 0
                          :to-p $ []
                            * r $ phlox.core/ffi-cos t2
                            * r $ phlox.core/ffi-sin t2
                        g :line-style $ {} (:color color) (:width 0) (:alpha 0)
                        g :arc $ {}
                          :center $ [] 0 0
                          :radius r
                          :angle $ [] t2 t
                          :anticlockwise? $ <
                            phlox.core/ffi-abs $ - t t2
                            , phlox.math/ffi-pi
          :examples $ []
          :schema $ :: 'Dynamic
        |shuffle $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn shuffle (xs) (js/console.warn "|TODO shuffle" xs) xs
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.chord-demo $ :require
            [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
            [] app.comp.reset :refer $ [] comp-reset
            [] app.util :refer $ [] rand-point rand-color
            [] phlox.comp.slider :refer $ [] comp-slider
            |@calcit/std :refer $ rand rand-int
    |app.comp.circle-demo $ %{} 'FileEntry
      :defs $ {}
        |comp-circle-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-circle-demo (touch-key)
              container
                {} $ :position ([] 0 140)
                comp-reset $ [] -80 -100
                create-list :container ({})
                  -> (range 60)
                    map $ fn (idx)
                      [] idx $ graphics
                        {}
                          :position $ [] 300 0
                          :ops $ generate-circle-ops idx
          :examples $ []
          :schema $ :: 'Dynamic
        |generate-circle-ops $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn generate-circle-ops (idx)
              loop
                  angle 0
                  acc $ []
                if
                  > angle $ + phlox.math/ffi-pi -0.3 (rand 1.4)
                  , acc $ let
                      ratio $ / 1 (inc idx)
                      a1 $ + angle (* 0.4 ratio)
                      a2 $ + a1
                        * 6 ratio $ phlox.core/ffi-random
                      r0 $ / 180 phlox.math/ffi-pi
                    recur
                      + a2 $ * 0.2 ratio
                      conj acc
                        g :line-style $ {}
                          :color $ * (phlox.core/ffi-random) (hslx 0 0 100)
                          :width 6
                          :alpha 0
                        g :arc $ {}
                          :center $ [] 0 0
                          :radius $ * 8 idx
                          :angle $ [] (* r0 angle) (* r0 a1)
                          :anticlockwise? false
                        g :line-style $ {}
                          :color $ * (phlox.core/ffi-random) (hslx 0 0 100)
                          :width 4
                          :alpha 1
                        g :arc $ {}
                          :center $ [] 0 0
                          :radius $ * 8 idx
                          :angle $ [] (* r0 a1) (* r0 a2)
                          :anticlockwise? false
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.circle-demo $ :require
            [] phlox.core :refer $ [] defcomp hslx rect circle text container graphics create-list hslx g
            [] app.comp.reset :refer $ [] comp-reset
            |@calcit/std :refer $ rand rand-int
    |app.comp.container $ %{} 'FileEntry
      :defs $ {}
        |cap-name $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn cap-name (x)
              str
                .!toUpperCase $ first x
                .slice x 1
          :examples $ []
          :schema $ :: 'Dynamic
        |comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-container (store)
              let
                  tab $ option:unwrap-or (get store :tab) nil
                  states $ option:unwrap-or (get store :states) nil
                  touch-key $ option:unwrap-or (get store :touch-key) nil
                container
                  {} $ :position ([] -250 -320)
                  create-list :container
                    {} $ :position ([] 40 40)
                    -> tabs $ map-indexed
                      fn (idx item)
                        [] idx $ comp-tab
                          cap-name $ turn-string item
                          , item idx (= tab item)
                  container
                    {} $ :position ([] 280 80)
                    case-default tab
                      text $ {}
                        :text $ str "|Unknown " tab
                        :style $ {}
                          :fill $ hslx 0 0 100
                        :position $ [] 0 0
                      :sun $ comp-sun-demo touch-key
                      nil $ comp-sun-demo touch-key
                      :circle $ comp-circle-demo touch-key
                      :tree $ comp-tree-demo (>> states :tree)
                      :walking $ comp-walking-demo touch-key
                      :grow $ comp-grow-demo touch-key
                      :rotate $ comp-rotate-demo (>> states :rotate)
                      :rects $ comp-rects-demo touch-key
                      :chars $ comp-chars-demo touch-key
                      :bezier $ comp-bezier-demo (>> states :bezier)
                      :cycloid $ comp-cycloid-demo (>> states :cycloid)
                      :chord $ comp-chord-demo (>> states :chord)
                      :oscillo $ comp-oscillo-demo (>> states :oscillo)
                      :geocentric $ comp-geocentric-demo (>> states :geocentric)
                      :snowflake $ comp-snowflake-demo (>> states :snowflake)
                      :harmono $ comp-harmono-demo (>> states :harmono)
                      :satellite $ comp-satellite-demo (>> states :satellite)
                  circle $ {}
                    :position $ [] 80 560
                    :fill $ hslx 200 90 30
                    :alpha 1
                    :radius 10
                    :on $ {}
                      :pointertap $ fn (e d!) (app.util/ffi-request-fullscreen js/document.body)
          :examples $ []
          :schema $ :: 'Dynamic
        |comp-tab $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-tab (title tab idx selected?)
              container
                {} $ :position
                  [] 0 $ * 32 idx
                rect $ {}
                  :position $ [] 0 0
                  :size $ [] 80 28
                  :fill $ hslx 200 60 (if selected? 30 14)
                  :on $ {}
                    :pointertap $ fn (e d!) (d! :tab tab)
                text $ {} (:text title)
                  :position $ [] 8 3
                  :style $ {}
                    :fill $ hslx 0 0 100
                    :font-size 20
                    :font-family style/font-fancy
          :examples $ []
          :schema $ :: 'Dynamic
        |tabs $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def tabs $ [] :sun :circle :rects :walking :grow :chars :cycloid :chord :oscillo :geocentric :rotate :bezier :tree :snowflake :harmono :satellite
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.container $ :require
            phlox.core :refer $ defcomp >> hslx rect circle text container graphics create-list hslx
            app.comp.sun-demo :refer $ comp-sun-demo
            app.comp.circle-demo :refer $ comp-circle-demo
            app.comp.tree-demo :refer $ comp-tree-demo
            app.comp.walking-demo :refer $ comp-walking-demo
            app.comp.grow-demo :refer $ comp-grow-demo
            app.comp.rotate-demo :refer $ comp-rotate-demo
            app.comp.rects-demo :refer $ comp-rects-demo
            app.comp.chars-demo :refer $ comp-chars-demo
            app.comp.bezier-demo :refer $ comp-bezier-demo
            app.comp.cycloid-demo :refer $ comp-cycloid-demo
            app.comp.chord-demo :refer $ comp-chord-demo
            app.comp.oscillo-demo :refer $ comp-oscillo-demo
            app.comp.geocentric-demo :refer $ comp-geocentric-demo
            app.comp.snowflake-demo :refer $ comp-snowflake-demo
            app.comp.harmono-demo :refer $ comp-harmono-demo
            app.comp.satellite-demo :refer $ comp-satellite-demo
            app.style :as style
            clojure.string :as string
    |app.comp.cycloid-demo $ %{} 'FileEntry
      :defs $ {}
        |comp-cycloid-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-cycloid-demo (states)
              let
                  cursor $ option:unwrap-or (get states :cursor) nil
                  state $ or
                    option:unwrap-or (get states :data) nil
                    {} (:r1 312) (:r2 80) (:r3 96) (:r4 20) (:r5 8) (:steps 2000) (:v 0.11) (:round? true)
                container ({}) (comp-numbers-control state states)
                  graphics $ {}
                    :position $ [] 400 400
                    :ops $ let
                        r1 $ option:unwrap-or (get state :r1) nil
                        r2 $ option:unwrap-or (get state :r2) nil
                        r3 $ option:unwrap-or (get state :r3) nil
                        r4 $ option:unwrap-or (get state :r4) nil
                        r5 $ option:unwrap-or (get state :r5) nil
                        trail $ ->
                          range $ option:unwrap-or (get state :steps) nil
                          map $ fn (idx)
                            let
                                t $ * idx
                                  option:unwrap-or (get state :v) nil
                                dr $ - r1 r2
                                dr2 $ - r2 r3
                                dr3 $ - r3 r4
                                dr4 $ - r4 r5
                                t2 $ negate
                                  / (* t r1) r2
                                t3 $ negate
                                  / (* t2 r2) r3
                                t4 $ negate
                                  / (* t3 r3) r4
                                t5 $ negate
                                  / (* t4 r4) r5
                              -> (polar-point dr t)
                                add-path $ if (zero? r2) ([] 0 0) (polar-point dr2 t2)
                                add-path $ if (zero? r3) ([] 0 0) (polar-point dr3 t3)
                                add-path $ if (zero? r4) ([] 0 0) (polar-point dr4 t4)
                                add-path $ if (zero? r5) ([] 0 0) (polar-point r5 t5)
                      concat
                        []
                          g :line-style $ {}
                            :color $ hslx 0 80 70
                            :width 2
                            :alpha 0.7
                          g :move-to $ or (first trail) ([] 0 0)
                        -> trail rest $ mapcat
                          fn (p)
                            [] $ g :line-to p
          :examples $ []
          :schema $ :: 'Dynamic
        |comp-numbers-control $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-numbers-control (state states)
              let
                  cursor $ option:unwrap-or (get states :cursor) nil
                  params $ [] :r1 :r2 :r3 :r4 :r5 :steps :v
                  is-round? $ option:unwrap-or (get state :round?) nil
                  rand-value $ fn ()
                    if is-round?
                      - (rand-int 300) 100
                      - (rand 300) 100
                container
                  {} $ :position ([] -40 -80)
                  create-list :container ({})
                    -> params $ map-indexed
                      fn (idx param)
                        [] idx $ comp-slider (>> states idx)
                          {}
                            :value $ get state param
                            :position $ [] (* idx 130) 30
                            :unit $ get-unit param
                            :round? $ if is-round? (get-round? param) false
                            :title $ turn-string param
                            :on-change $ fn (v d!)
                              d! cursor $ assoc state param (round-value v param)
                  comp-switch $ {} (:value is-round?) (:title "|Round value?")
                    :position $ [] 0 100
                    :on-change $ fn (e d!)
                      d! cursor $ update state :round? not
                  comp-button $ {} (:text |rand2)
                    :position $ [] 100 80
                    :on-pointertap $ fn (e d!)
                      d! cursor $ merge state
                        {}
                          :r1 $ rand-value
                          :r2 $ rand-value
                          :r3 0
                          :r4 0
                          :r5 0
                  comp-button $ {} (:text |rand3)
                    :position $ [] 240 80
                    :on-pointertap $ fn (e d!)
                      d! cursor $ merge state
                        {}
                          :r1 $ rand-value
                          :r2 $ rand-value
                          :r3 $ rand-value
                          :r4 0
                          :r5 0
                  comp-button $ {} (:text |rand4)
                    :position $ [] 380 80
                    :on-pointertap $ fn (e d!)
                      d! cursor $ merge state
                        {}
                          :r1 $ rand-value
                          :r2 $ rand-value
                          :r3 $ rand-value
                          :r4 $ rand-value
                          :r5 0
                  comp-button $ {} (:text |rand5)
                    :position $ [] 520 80
                    :on-pointertap $ fn (e d!)
                      d! cursor $ merge state
                        {}
                          :r1 $ rand-value
                          :r2 $ rand-value
                          :r3 $ rand-value
                          :r4 $ rand-value
                          :r5 $ rand-value
          :examples $ []
          :schema $ :: 'Dynamic
        |get-round? $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn get-round? (param)
              case param (:r1 true) (:r2 true) (:r3 true) (:r4 true) (:r5 true) (:steps true) (do false)
          :examples $ []
          :schema $ :: 'Dynamic
        |get-unit $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn get-unit (param)
              case-default param 1 (:r1 0.2) (:r2 0.1) (:r3 0.04) (:r4 0.04) (:r5 0.04) (:steps 20) (:v 0.001)
          :examples $ []
          :schema $ :: 'Dynamic
        |polar-point $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn polar-point (r theta)
              []
                * r $ phlox.core/ffi-cos theta
                * r $ phlox.core/ffi-sin theta
          :examples $ []
          :schema $ :: 'Dynamic
        |round-value $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn round-value (v param)
              case-default param v $ :steps
                js/Math.max 0 $ js/Math.round v
          :examples $ []
          :schema $ :: 'Dynamic
        |zero? $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn zero? (x) (= x 0)
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.cycloid-demo $ :require
            [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
            [] app.comp.reset :refer $ [] comp-reset
            [] app.util :refer $ [] rand-point add-path subtract-path multiply-path
            [] phlox.comp.button :refer $ [] comp-button
            [] phlox.comp.slider :refer $ [] comp-slider
            [] phlox.comp.switch :refer $ [] comp-switch
            |@calcit/std :refer $ rand rand-int
    |app.comp.geocentric-demo $ %{} 'FileEntry
      :defs $ {}
        |comp-geocentric-control $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-geocentric-control (state states)
              container
                {} $ :position ([] 0 -20)
                create-list :container ({})
                  -> ([] :r2 :v2 :r3 :v3 :steps :step)
                    map-indexed $ fn (idx param)
                      [] idx $ comp-slider (>> states param)
                        {}
                          :title $ turn-string param
                          :position $ [] (* idx 140) 0
                          :value $ get state param
                          :unit $ case-default param 1 (:step 0.001) (:steps 10)
                          :on-change $ fn (value d!)
                            d!
                              option:unwrap-or (get states :cursor) nil
                              assoc state param $ case-default param value
                                :r2 $ js/Math.max 1 (js/Math.round value)
                                :v2 $ js/Math.max 1 (js/Math.round value)
                                :r3 $ js/Math.max 1 (js/Math.round value)
                                :v3 $ js/Math.max 1 (js/Math.round value)
                                :steps $ js/Math.round value
                comp-button $ {} (:text |Random)
                  :position $ [] 580 40
                  :on-pointertap $ fn (e d!)
                    d!
                      option:unwrap-or (get states :cursor) nil
                      {}
                        :r2 $ rand-int 200
                        :v2 $ rand 3
                        :r3 $ rand-int 200
                        :v3 $ rand 3
                        :steps 4000
                        :step 0.1
          :examples $ []
          :schema $ :: 'Dynamic
        |comp-geocentric-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-geocentric-demo (states)
              let
                  state $ or
                    option:unwrap-or (get states :data) nil
                    , initial-state
                container ({})
                  graphics $ {}
                    :position $ [] 400 360
                    :ops $ let
                        steps $ option:unwrap-or (get state :steps) nil
                        step $ option:unwrap-or (get state :step) nil
                        r2 $ option:unwrap-or (get state :r2) nil
                        r3 $ option:unwrap-or (get state :r3) nil
                        trail $ -> (range steps)
                          map $ fn (idx)
                            let
                                t $ * idx step
                              add-path
                                add-path
                                  []
                                    * 200 $ phlox.core/ffi-cos t
                                    * 200 $ phlox.core/ffi-sin t
                                  []
                                    * r2 $ phlox.core/ffi-cos
                                      * t $ option:unwrap-or (get state :v2) nil
                                    * r2 $ phlox.core/ffi-sin
                                      * t $ option:unwrap-or (get state :v2) nil
                                []
                                  * r3 $ phlox.core/ffi-cos
                                    * t $ option:unwrap-or (get state :v3) nil
                                  * r3 $ phlox.core/ffi-sin
                                    * t $ option:unwrap-or (get state :v3) nil
                      concat
                        []
                          g :move-to $ first trail
                          g :line-style $ {}
                            :color $ hslx 0 80 80
                            :width 2
                            :alpha 1
                        -> trail rest $ map
                          fn (point) ([] :line-to point)
                  comp-geocentric-control state states
          :examples $ []
          :schema $ :: 'Dynamic
        |get-unit $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn get-unit (param)
              case-default param 1 (:r2 1) (:r3 0.5) (:v2 0.2) (:v3 0.2) (:steps 100) (:step 0.001)
          :examples $ []
          :schema $ :: 'Dynamic
        |initial-state $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def initial-state $ {} (:r2 100) (:r3 16) (:v2 30) (:v3 260) (:steps 2000) (:step 0.002) (:selected :r2)
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.geocentric-demo $ :require
            [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
            [] app.util :refer $ [] rand-point rand-color add-path
            [] phlox.comp.button :refer $ [] comp-button
            [] phlox.comp.slider :refer $ [] comp-slider
            |@calcit/std :refer $ rand rand-int
    |app.comp.grow-demo $ %{} 'FileEntry
      :defs $ {}
        |*grid $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defatom *grid $ {}
          :examples $ []
          :schema $ :: 'Dynamic
        |comp-grow-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-grow-demo (touch-key)
              let
                  trails $ generate-trails
                container ({})
                  create-list :container
                    {} $ :position ([] 700 400)
                    -> trails $ map-indexed
                      fn (idx trail)
                        [] idx $ graphics
                          {}
                            :position $ [] 0 0
                            :ops $ get-trail-ops trail
                  comp-reset $ [] 0 0
          :examples $ []
          :schema $ :: 'Dynamic
        |expand-directions $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn expand-directions (base)
              []
                add-path base $ [] 0 -1
                add-path base $ [] 0 1
                add-path base $ [] 1 0
                add-path base $ [] -1 0
          :examples $ []
          :schema $ :: 'Dynamic
        |generate-trails $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn generate-trails ()
              reset! *grid $ {}
              let
                  trails $ -> (range 12)
                    map $ fn (x) (rand-point 140 60)
                    distinct
                &doseq (point trails) (swap! *grid assoc point true)
                loop
                    idx 50
                    points-with-keys $ map trails
                      fn (x)
                        [] (shortid/generate) x
                    acc $ []
                  if (= 0 idx)
                    do $ -> acc (group-by first) (.to-list) (.map last)
                      map $ fn (x)
                        -> x $ map
                          fn (y) (.slice y 1)
                    let-sugar
                          [] new-points-keys pieces
                          iterate-trails points-with-keys
                      recur (dec idx) new-points-keys $ concat acc pieces
          :examples $ []
          :schema $ :: 'Dynamic
        |get-trail-ops $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn get-trail-ops (trail)
              let
                  zoom-in $ [] 6 0
                concat
                  [] $ g :line-style
                    {}
                      :color $ hslx (rand 360)
                        + 20 $ rand-int 80
                        + 20 $ rand-int 80
                      :width 2
                      :alpha 1
                  -> trail rest $ mapcat
                    fn (stop)
                      []
                        g :move-to $ multiply-path (first stop) zoom-in
                        g :line-to $ multiply-path (last stop) zoom-in
          :examples $ []
          :schema $ :: 'Dynamic
        |iterate-trails $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn iterate-trails (points)
              let
                  result $ -> points
                    map $ fn (pair)
                      let-sugar
                            [] k base
                            , pair
                          directions $ expand-directions base
                          available $ -> directions
                            filter-not $ fn (x) (get @*grid x)
                            filter $ fn (x)
                              > (rand) 0.43
                        let
                            picked $ pick-many available
                          &doseq (x picked) (swap! *grid assoc x true)
                          []
                            -> picked $ map
                              fn (x) ([] k x)
                            -> picked $ map
                              fn (x) ([] k base x)
                []
                  ->
                    concat $ mapcat result app.util/first-list
                    filter-not $ fn (pair)
                      let-sugar
                            [] k point
                            , pair
                          directions $ expand-directions point
                          available $ -> directions
                            filter-not $ fn (x) (get @*grid x)
                        empty? available
                  mapcat result app.util/last-list
          :examples $ []
          :schema $ :: 'Dynamic
        |pick-many $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn pick-many (xs)
              if
                = 3 $ count xs
                case-default (rand-int 3) xs
                  0 $ .slice xs 1
                  1 $ [] (nth xs 0) (nth xs 2)
                  2 $ .slice xs 0 2
                , xs
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.grow-demo $ :require
            [] phlox.core :refer $ [] defcomp g hslx rect circle text container graphics create-list hslx
            [] app.util :refer $ [] add-path multiply-path
            [] app.comp.reset :refer $ [] comp-reset
            [] clojure.core.rrb-vector :refer $ [] catvec
            [] |shortid :as shortid
            [] app.util :refer $ [] rand-point
            |@calcit/std :refer $ rand rand-int
    |app.comp.harmono-demo $ %{} 'FileEntry
      :defs $ {}
        |comp-harmono-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-harmono-demo (states)
              let
                  cursor $ option:unwrap-or (get states :cursor) nil
                  state $ or
                    option:unwrap-or (get states :data) nil
                    {}
                      :controls $ -> (range 3)
                        map $ fn (i)
                          {}
                            :amplitude $ rand-point 40
                            :frequency $ rand 10
                            :phase 6
                            :damping $ rand 2
                      :steps 100
                      :base 0.01
                  controls $ option:unwrap-or (get state :controls) nil
                  trail $ gen-trail controls
                    option:unwrap-or (get state :steps) nil
                    option:unwrap-or (get state :base) nil
                container
                  {} $ :position ([] 400 300)
                  render-controls cursor states state controls
                  container ({})
                    graphics $ {}
                      :position $ [] 0 80
                      :ops $ concat
                        []
                          g :move-to $ first trail
                          g :line-style $ {}
                            :color $ hslx 0 0 100
                            :width 1
                            :alpha 1
                        -> (rest trail)
                          map-indexed $ fn (idx point) (g :line-to point)
                    render-points cursor states state controls
          :examples $ []
          :schema $ :: 'Dynamic
        |gen-trail $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn gen-trail (controls steps base)
              -> (range steps)
                map $ fn (idx)
                  let
                      t $ * idx base
                      final-point $ -> controls
                        map $ fn (control)
                          multiply-path
                            []
                              *
                                phlox.core/ffi-sin $ +
                                  * t $ option:unwrap-or (get control :frequency) nil
                                  option:unwrap-or (get control :phase) nil
                                app.util/ffi-pow app.util/ffi-e $ * -1
                                  option:unwrap-or (get control :damping) nil
                                  , t
                              , 0
                            option:unwrap-or (get control :amplitude) nil
                        reduce ([] 0 0) add-path
                    , final-point
          :examples $ []
          :schema $ :: 'Dynamic
        |render-controls $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn render-controls (cursor states state controls)
              container
                {} $ :position ([] 0 -340)
                comp-slider (>> states :steps)
                  {}
                    :position $ [] 0 0
                    :value $ option:unwrap-or (get state :steps) nil
                    :unit 10
                    :round? true
                    :min 0
                    :title |steps
                    :on-change $ fn (v d!)
                      d! cursor $ assoc state :steps v
                comp-slider (>> states :base)
                  {}
                    :position $ [] 140 0
                    :value $ option:unwrap-or (get state :base) nil
                    :unit 0.001
                    :round? false
                    :min 0
                    :title |base
                    :on-change $ fn (v d!)
                      d! cursor $ assoc state :base v
                create-list :container ({})
                  -> controls $ map-indexed
                    fn (idx control)
                      [] idx $ container
                        {} $ :position
                          []
                            - (* idx 140) 600
                            , 0
                        comp-slider
                          >> states $ str |frequency: idx
                          {}
                            :position $ [] 140 0
                            :value $ option:unwrap-or (get control :frequency) nil
                            :unit 0.1
                            :round? true
                            :min 0
                            :title |frequency
                            :on-change $ fn (v d!)
                              d! cursor $ assoc-in state ([] :controls idx :frequency) v
                        comp-slider
                          >> states $ str |phase: idx
                          {}
                            :position $ [] 140 50
                            :value $ option:unwrap-or (get control :phase) nil
                            :unit 0.1
                            :round? false
                            :min 0
                            :title |phase
                            :on-change $ fn (v d!)
                              d! cursor $ assoc-in state ([] :controls idx :phase) v
                        comp-slider
                          >> states $ str |damping: idx
                          {}
                            :position $ [] 140 100
                            :value $ option:unwrap-or (get control :damping) nil
                            :unit 0.01
                            :round? false
                            :min 0
                            :title |damping
                            :on-change $ fn (v d!)
                              d! cursor $ assoc-in state ([] :controls idx :damping) v
          :examples $ []
          :schema $ :: 'Dynamic
        |render-points $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn render-points (cursor states state controls)
              create-list :container ({})
                -> controls $ map-indexed
                  fn (idx control)
                    [] idx $ comp-drag-point
                      >> states $ str |amplitude: idx
                      {}
                        :position $ option:unwrap-or (get control :amplitude) nil
                        :on-change $ fn (v d!)
                          d! cursor $ assoc-in state ([] :controls idx :amplitude) v
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.harmono-demo $ :require
            [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
            [] app.util :refer $ [] rand-point rand-color add-path multiply-path
            [] phlox.comp.slider :refer $ [] comp-slider
            [] phlox.comp.drag-point :refer $ [] comp-drag-point
            |@calcit/std :refer $ rand
    |app.comp.oscillo-demo $ %{} 'FileEntry
      :defs $ {}
        |comp-oscillo-control $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-oscillo-control (state states)
              container ({})
                create-list :container ({})
                  -> ([] :m :n :step :unit)
                    map-indexed $ fn (idx param)
                      [] idx $ comp-slider (>> states param)
                        {}
                          :value $ get state param
                          :title $ turn-string param
                          :position $ [] (* 140 idx) 0
                          :round? $ get-round? param
                          :unit $ case-default param 0.1 (:unit 0.001) (:step 1)
                          :on-change $ fn (value d!)
                            d!
                              option:unwrap-or (get states :cursor) nil
                              assoc state param $ case-default param (js/Math.max 0 value)
                                :m $ js/Math.max 1 (js/Math.round value)
                                :n $ js/Math.max 1 (js/Math.round value)
                                :step $ js/Math.max 1 (js/Math.round value)
                comp-button $ {} (:text |Random)
                  :position $ [] 580 0
                  :on-pointertap $ fn (e d!)
                    d!
                      option:unwrap-or (get states :cursor) nil
                      {}
                        :m $ rand-int 40
                        :n $ rand-int 40
                        :step 500
                        :unit 0.01
          :examples $ []
          :schema $ :: 'Dynamic
        |comp-oscillo-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-oscillo-demo (states)
              let
                  cursor $ option:unwrap-or (get states :cursor) nil
                  state $ or
                    option:unwrap-or (get states :data) nil
                    , initial-state
                container ({})
                  graphics $ {}
                    :position $ [] 400 360
                    :ops $ let
                        step $ option:unwrap-or (get state :step) nil
                        r 200
                        m $ option:unwrap-or (get state :m) nil
                        n $ option:unwrap-or (get state :n) nil
                        unit $ option:unwrap-or (get state :unit) nil
                        trail $ -> (range step)
                          map $ fn (idx)
                            let
                                t $ * idx unit
                              []
                                * r $ phlox.core/ffi-cos (* m t)
                                * r $ phlox.core/ffi-sin (* n t)
                      concat
                        []
                          g :move-to $ first trail
                          g :line-style $ {}
                            :color $ rand-color
                            :width 2
                            :alpha 1
                        -> trail rest $ map
                          fn (point) ([] :line-to point)
                  comp-oscillo-control state states
          :examples $ []
          :schema $ :: 'Dynamic
        |get-round? $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn get-round? (param)
              case param (:unit false) (do true)
          :examples $ []
          :schema $ :: 'Dynamic
        |initial-state $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def initial-state $ {} (:step 1000) (:unit 0.01) (:m 13) (:n 3)
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.oscillo-demo $ :require
            [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
            [] app.util :refer $ [] rand-point rand-color
            [] phlox.comp.button :refer $ [] comp-button
            [] phlox.comp.slider :refer $ [] comp-slider
            |@calcit/std :refer $ rand rand-int
    |app.comp.rects-demo $ %{} 'FileEntry
      :defs $ {}
        |comp-rects-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-rects-demo (touch-key)
              container ({})
                create-list :container
                  {} $ :position ([] 40 40)
                  -> (range 10)
                    mapcat $ fn (x)
                      -> (range 10)
                        map $ fn (y)
                          [] (str x |+ y)
                            container
                              {} $ :position
                                [] (* x 60) (* y 60)
                              rect $ {}
                                :size $ []
                                  * 15 $ rand-int 16
                                  * 15 $ rand-int 16
                                :angle $ * 45 (rand-int 4)
                                :position $ []
                                  * 15 $ rand-int 4
                                  * 15 $ rand-int 4
                                :line-style $ {}
                                  :color $ rand (hslx 0 0 100)
                                  :width $ rand-int 4
                                  :alpha 1
                                :alpha 1
                              rect $ {}
                                :size $ []
                                  * 15 $ rand-int 5
                                  * 15 $ rand-int 5
                                :position $ []
                                  * 15 $ rand-int 6
                                  * 15 $ rand-int 6
                                :fill $ rand (hslx 0 0 100)
                                :angle $ * 45 (rand-int 4)
                                :alpha 0.9
                              rect $ {}
                                :size $ []
                                  * 15 $ inc (rand-int 2)
                                  * 15 $ inc (rand-int 2)
                                :position $ []
                                  * 15 $ rand-int 16
                                  * 15 $ rand-int 16
                                :angle $ * 45 (rand-int 4)
                                :alpha $ rand 1
                                :line-style $ {}
                                  :color $ rand (hslx 0 0 100)
                                  :width 2
                                  :alpha 1
                comp-reset $ [] -40 40
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.rects-demo $ :require
            [] phlox.core :refer $ [] defcomp hslx g rect circle text container graphics create-list hslx
            [] app.comp.reset :refer $ [] comp-reset
            [] app.util :refer $ [] rand-point
            |@calcit/std :refer $ rand rand-int
    |app.comp.reset $ %{} 'FileEntry
      :defs $ {}
        |comp-reset $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-reset (position)
              container
                {} $ :position position
                rect $ {}
                  :position $ [] 0 0
                  :size $ [] 80 40
                  :fill $ hslx 0 0 40
                  :on $ {}
                    :pointertap $ fn (e d!) (d! :touch nil)
                text $ {} (:text |Refresh)
                  :position $ [] 8 6
                  :style $ {} (:font-family style/font-fancy)
                    :fill $ hslx 0 0 100
                    :font-size 20
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.reset $ :require
            [] phlox.core :refer $ [] defcomp hslx rect circle text container graphics create-list hslx
            [] app.style :as style
    |app.comp.rotate-demo $ %{} 'FileEntry
      :defs $ {}
        |comp-rotate-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-rotate-demo (states)
              let
                  cursor $ option:unwrap-or (get states :cursor) nil
                  state $ or
                    option:unwrap-or (get states :data) nil
                    {}
                      :points $ -> (range 12)
                        map $ fn (idx)
                          []
                            + 200 $ rand 100
                            rand 100
                      :steps 18
                      :base 20
                      :alpha 1
                  points $ option:unwrap-or (get state :points) nil
                container
                  {} $ :position ([] 240 400)
                  create-list :container ({})
                    ->
                      range $ option:unwrap-or (get state :steps) nil
                      map $ fn (idx)
                        [] idx $ graphics
                          {}
                            :ops $ gen-trail points
                              option:unwrap-or (get state :alpha) nil
                            :angle $ * idx
                              option:unwrap-or (get state :base) nil
                  create-list :container ({})
                    -> points $ map-indexed
                      fn (idx point)
                        [] idx $ comp-drag-point (>> states idx)
                          {} (:position point)
                            :fill $ hslx
                              cond
                                  < idx 4
                                  , 0
                                (< idx 8) 120
                                true 240
                              , 100 70
                            :on-change $ fn (v d!)
                              d! cursor $ assoc-in state ([] :points idx) v
                  create-list :container ({})
                    -> ([] :steps :base :alpha)
                      map-indexed $ fn (idx param)
                        [] param $ comp-slider (>> states param)
                          {}
                            :title $ turn-string param
                            :value $ get state param
                            :unit $ case-default param 1 (:steps 0.4) (:alpha 0.004) (:base 0.2)
                            :round? $ get-round? param
                            :on-change $ fn (v d!)
                              d! cursor $ assoc state param
                                case-default param v
                                  :steps $ js/Math.max 1 (js/Math.round v)
                                  :alpha $ js/Math.max 0 (js/Math.min 1 v)
                            :position $ []
                              + -400 $ * idx 140
                              , -440
          :examples $ []
          :schema $ :: 'Dynamic
        |gen-trail $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn gen-trail (points alpha)
              []
                g :move-to $ get points 0
                g :line-style $ {}
                  :color $ hslx 0 100 70
                  :width 2
                  :alpha alpha
                g :bezier-to $ {}
                  :p1 $ get points 1
                  :p2 $ get points 2
                  :to-p $ get points 3
                g :move-to $ get points 4
                g :line-style $ {}
                  :color $ hslx 120 100 70
                  :width 2
                  :alpha alpha
                g :bezier-to $ {}
                  :p1 $ get points 5
                  :p2 $ get points 6
                  :to-p $ get points 7
                g :move-to $ get points 8
                g :line-style $ {}
                  :color $ hslx 240 100 70
                  :width 2
                  :alpha alpha
                g :bezier-to $ {}
                  :p1 $ get points 9
                  :p2 $ get points 10
                  :to-p $ get points 11
          :examples $ []
          :schema $ :: 'Dynamic
        |get-round? $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn get-round? (param)
              case param (:steps true) (do false)
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.rotate-demo $ :require
            [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
            [] app.comp.reset :refer $ [] comp-reset
            [] app.util :refer $ [] rand-point
            [] phlox.comp.drag-point :refer $ [] comp-drag-point
            [] phlox.comp.slider :refer $ [] comp-slider
            |@calcit/std :refer $ rand rand-int
    |app.comp.satellite-demo $ %{} 'FileEntry
      :defs $ {}
        |comp-number-controls $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-number-controls (state states)
              let
                  cursor $ option:unwrap-or (get states :cursor) nil
                  selected $ get state :selected
                  segment $ get-in state ([] :segments selected)
                container ({})
                  comp-slider (>> states :unit)
                    {}
                      :value $ option:unwrap-or (get state :unit) nil
                      :unit 0.1
                      :min 0
                      :title |unit
                      :on-change $ fn (result d!)
                        d! cursor $ assoc state :unit result
                  comp-slider (>> states :selected)
                    {}
                      :value $ option:unwrap-or (get state :selected) nil
                      :position $ [] 140 0
                      :unit 0.1
                      :round? true
                      :min 0
                      :max $ dec
                        count $ option:unwrap-or (get state :segments) nil
                      :title |selected
                      :on-change $ fn (result d!)
                        d! cursor $ assoc state :selected result
                  comp-slider (>> states :from)
                    {}
                      :value $ get-in state
                        [] :segments
                          option:unwrap-or (get state :selected) nil
                          , 0
                      :position $ [] 280 0
                      :unit 1
                      :round? true
                      :title "|from angle"
                      :on-change $ fn (result d!)
                        d! cursor $ assoc-in state
                          [] :segments
                            option:unwrap-or (get state :selected) nil
                            , 0
                          , result
                  comp-slider (>> states :to)
                    {}
                      :value $ get-in state
                        [] :segments
                          option:unwrap-or (get state :selected) nil
                          , 1
                      :position $ [] 420 0
                      :unit 1
                      :round? true
                      :min 0
                      :max 360
                      :title |range
                      :on-change $ fn (result d!)
                        d! cursor $ assoc-in state
                          [] :segments
                            option:unwrap-or (get state :selected) nil
                            , 1
                          , result
                  comp-button $ {} (:text |Add)
                    :position $ [] 600 0
                    :on $ {}
                      :pointertap $ fn (e d!)
                        d! cursor $ -> state
                          update :segments $ fn (xs)
                            conj xs $ [] (rand-int 360) (rand-int 360)
                          assoc :selected $ count
                            option:unwrap-or (get state :segments) nil
                  comp-button $ {} (:text |Remove)
                    :position $ [] 660 0
                    :on $ {}
                      :pointertap $ fn (e d!)
                        d! cursor $ -> state
                          update :segments $ fn (xs)
                            if
                              < (count xs) 2
                              , xs $ butlast xs
                          assoc :selected 0
          :examples $ []
          :schema $ :: 'Dynamic
        |comp-satellite-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-satellite-demo (states)
              let
                  cursor $ option:unwrap-or (get states :cursor) nil
                  state $ or
                    option:unwrap-or (get states :data) nil
                    {} (:unit 20)
                      :segments $ [] ([] 0 100) ([] 50 200) ([] 100 180)
                      :selected 0
                  ratio $ * phlox.math/ffi-pi (/ 1 180)
                  rad $ fn (x) (* x ratio)
                container ({}) (comp-number-controls state states)
                  create-list :container
                    {} $ :position ([] 400 400)
                    ->
                      option:unwrap-or (get state :segments) nil
                      map-indexed $ fn (idx segment)
                        [] idx $ let
                            r $ + 10
                              * idx $ option:unwrap-or (get state :unit) nil
                          graphics $ {}
                            :ops $ []
                              g :line-style $ {}
                                :color $ if
                                  = idx $ option:unwrap-or (get state :selected) nil
                                  hslx 0 0 100
                                  hslx 20 80 70
                                :width $ if
                                  = idx $ option:unwrap-or (get state :selected) nil
                                  , 2 2
                                :alpha 1
                              ; g :begin-fill $ {}
                                :color $ hslx 20 80 70
                              g :arc $ {}
                                :center $ let
                                    th $ first segment
                                  []
                                    * r $ phlox.core/ffi-cos (rad th)
                                    * r $ phlox.core/ffi-sin (rad th)
                                :radius 4
                                :angle $ [] 0 360
                              g :arc $ {}
                                :center $ [] 0 0
                                :radius r
                                :angle $ let
                                    segment $ get-in state ([] :segments idx)
                                  [] (first segment)
                                    + (first segment) (last segment)
                              g :arc $ {}
                                :center $ let
                                    th $ + (first segment) (last segment)
                                  []
                                    * r $ phlox.core/ffi-cos (rad th)
                                    * r $ phlox.core/ffi-sin (rad th)
                                :radius 4
                                :angle $ [] 0 360
                              g :end-fill nil
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.satellite-demo $ :require
            [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
            [] app.comp.reset :refer $ [] comp-reset
            [] app.util :refer $ [] rand-point
            [] phlox.comp.slider :refer $ [] comp-slider
            [] phlox.comp.button :refer $ [] comp-button
            |@calcit/std :refer $ rand rand-int
    |app.comp.snowflake-demo $ %{} 'FileEntry
      :defs $ {}
        |comp-snowflake-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-snowflake-demo (states)
              let
                  cursor $ option:unwrap-or (get states :cursor) nil
                  state $ or
                    option:unwrap-or (get states :data) nil
                    {} (:steps 1)
                      :points $ [] ([] 0 300) ([] 140 300)
                      :shaking? false
                container ({})
                  container
                    {} $ :position ([] -100 -60)
                    comp-button $ {} (:text |Add)
                      :position $ [] -60 0
                      :on $ {}
                        :pointertap $ fn (e d!)
                          d! cursor $ update state :points
                            fn (points)
                              conj (butlast points)
                                add-path (last points) ([] -80 -60)
                                last points
                    comp-button $ {} (:text |Reduce)
                      :position $ [] 0 0
                      :on $ {}
                        :pointertap $ fn (e d!)
                          d! cursor $ update state :points
                            fn (points)
                              if
                                <= (count points) 2
                                , points $ conj
                                  butlast $ butlast points
                                  last points
                    comp-slider (>> states :steps)
                      {}
                        :value $ option:unwrap-or (get state :steps) nil
                        :position $ [] 80 0
                        :unit 0.1
                        :title |Steps
                        :min 0
                        :max $ if
                          >= 3 $ count
                            option:unwrap-or (get state :points) nil
                          , 12 6
                        :round? true
                        :on-change $ fn (value d!)
                          d! cursor $ assoc state :steps value
                    comp-switch $ {}
                      :value $ option:unwrap-or (get state :shaking?) nil
                      :position $ [] 200 0
                      :title |Shake
                      :on-change $ fn (v d!)
                        d! cursor $ assoc state :shaking? v
                  graphics $ {}
                    :position $ [] 0 0
                    :ops $ let
                        trail $ fold-curve
                          option:unwrap-or (get state :points) nil
                          option:unwrap-or (get state :steps) nil
                          option:unwrap-or (get state :shaking?) nil
                      concat
                        []
                          g :move-to $ first trail
                          g :line-style $ {}
                            :color $ hslx 0 0 100
                            :width 1
                            :alpha 1
                        -> (rest trail)
                          map-indexed $ fn (idx point) (g :line-to point)
                  create-list :container ({})
                    ->
                      option:unwrap-or (get state :points) nil
                      map-indexed $ fn (idx point)
                        [] idx $ comp-drag-point (>> states idx)
                          {} (:position point)
                            :title $ str |p idx
                            :alpha 0.5
                            :color $ hslx 300 80 50
                            :on-change $ fn (position d!)
                              d! cursor $ assoc-in state ([] :points idx) position
          :examples $ []
          :schema $ :: 'Dynamic
        |fold-curve $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn fold-curve (points steps shaking?)
              let
                  template-points $ -> (rest points)
                    map $ fn (point)
                      subtract-path point $ first points
                  template-path $ last template-points
                  inverted $ divide-path ([] 1 0) template-path
                loop
                    t steps
                    acc points
                  if (<= t 0) acc $ recur (dec t)
                    let
                        acc-vec acc
                      concat
                        [] $ first acc
                        -> (rest acc)
                          map-indexed $ fn (idx point)
                            let
                                from $ get acc-vec idx
                              -> template-points $ map
                                fn (pi)
                                  add-path from $ multiply-path (subtract-path point from)
                                    if
                                      and shaking? $ odd? idx
                                      invert-y $ multiply-path pi inverted
                                      multiply-path pi inverted
                          mapcat identity
          :examples $ []
          :schema $ :: 'Dynamic
        |odd? $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn odd? (n)
              not= 0 $ .rem n 2
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.snowflake-demo $ :require
            [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
            [] app.comp.reset :refer $ [] comp-reset
            [] app.util :refer $ [] rand-point add-path subtract-path divide-x multiply-path divide-path invert-y
            [] phlox.comp.drag-point :refer $ [] comp-drag-point
            [] phlox.comp.button :refer $ [] comp-button
            [] phlox.comp.slider :refer $ [] comp-slider
            [] phlox.comp.switch :refer $ [] comp-switch
    |app.comp.sun-demo $ %{} 'FileEntry
      :defs $ {}
        |comp-sun-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-sun-demo (touch-key)
              container
                {} $ :position ([] 40 200)
                comp-reset $ [] -200 -200
                create-list :container
                  {} $ :position ([] 200 40)
                  -> (range 200)
                    map $ fn (x)
                      [] x $ graphics
                        {}
                          :position $ [] 0 0
                          :rotation $ * 0.010 phlox.math/ffi-pi x
                          :ops $ generate-line-ops
          :examples $ []
          :schema $ :: 'Dynamic
        |generate-line-ops $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn generate-line-ops () $ let
                x0 2
                ops $ []
                  g :move-to $ []
                    + x0 $ * 400 (phlox.core/ffi-random)
                    , 0
              loop
                  acc ops
                  x x0
                if (> x 300) acc $ let
                    x1 $ + x
                      * 80 $ phlox.core/ffi-random
                    x2 $ + x1
                      + 4 $ * 8 (phlox.core/ffi-random)
                  recur
                    conj acc
                      g :line-style $ {}
                        :color $ * (phlox.core/ffi-random) (hslx 0 0 100)
                        :width $ if (< x2 160) 2 3
                        :alpha $ if (< x2 80) 0.2 0.9
                      g :line-to $ [] x1 0
                      g :move-to $ [] x2 0
                    , x2
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.sun-demo $ :require
            [] phlox.core :refer $ [] defcomp g hslx rect circle text container graphics create-list hslx
            [] app.comp.reset :refer $ [] comp-reset
    |app.comp.tree-demo $ %{} 'FileEntry
      :defs $ {}
        |comp-tree-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-tree-demo (states)
              let
                  cursor $ option:unwrap-or (get states :cursor) nil
                  state $ or
                    option:unwrap-or (get states :data) nil
                    {}
                      :p1 $ [] 0.7 0.2
                      :p2 $ [] 0.84 0.15
                      :p0 $ [] 3 -80
                  p0 $ option:unwrap-or (get state :p0) nil
                  base $ subtract-path ([] 0 0) p0
                  factor-1 $ divide-path
                    option:unwrap-or (get state :p1) nil
                    , base
                  factor-2 $ divide-path
                    option:unwrap-or (get state :p2) nil
                    , base
                container
                  {} $ :position ([] 0 200)
                  graphics $ {}
                    :position $ [] 0 0
                    :ops $ let
                        trail $ []
                          [] :move-to $ [] 0 0
                          [] :line-style $ {}
                            :color $ hslx 0 0 100
                            :width 1
                            :alpha 1
                          [] :line-to p0
                      concat trail $ generate-branches p0 base 0 factor-1 factor-2
                  comp-drag-point (>> states :p1)
                    {}
                      :position $ option:unwrap-or (get state :p1) nil
                      :radius 10
                      :fill $ hslx 200 80 60
                      :alpha 0.4
                      :on-change $ fn (position d!)
                        d! cursor $ assoc state :p1 position
                  comp-drag-point (>> states :p2)
                    {}
                      :position $ option:unwrap-or (get state :p2) nil
                      :title |end
                      :radius 10
                      :alpha 0.4
                      :fill $ hslx 200 80 60
                      :on-change $ fn (position d!)
                        d! cursor $ assoc state :p2 position
                  comp-drag-point (>> states :p0)
                    {}
                      :position $ option:unwrap-or (get state :p0) nil
                      :title |from
                      :radius 10
                      :alpha 0.5
                      :fill $ hslx 100 90 80
                      :on-change $ fn (position d!)
                        d! cursor $ assoc state :p0 position
          :examples $ []
          :schema $ :: 'Dynamic
        |generate-branches $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn generate-branches (from arrow level factor-1 factor-2)
              let
                  next-from $ add-path from arrow
                  next-p1 $ add-path next-from (multiply-path factor-1 arrow)
                  next-p2 $ add-path next-from (multiply-path factor-2 arrow)
                  trail $ [] (g :move-to next-p1) (g :line-to next-from) (g :line-to next-p2)
                  too-deep? $ or (> level 8)
                    < (rough-size arrow) 4
                if too-deep? trail $ concat trail
                  generate-branches next-from (multiply-path factor-1 arrow) (inc level) factor-1 factor-2
                  generate-branches next-from (multiply-path factor-2 arrow) (inc level) factor-1 factor-2
          :examples $ []
          :schema $ :: 'Dynamic
        |should-shrink? $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn should-shrink? (level)
              cond
                  < level 4
                  , false
                (> level 8) true
                true $ > (rand 2) 1.4
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.tree-demo $ :require
            [] phlox.core :refer $ [] defcomp >> g hslx rect circle text container graphics create-list hslx
            [] app.util :refer $ [] add-path multiply-path subtract-path divide-path rough-size
            [] phlox.comp.drag-point :refer $ [] comp-drag-point
    |app.comp.walking-demo $ %{} 'FileEntry
      :defs $ {}
        |*grid $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defatom *grid $ {}
          :examples $ []
          :schema $ :: 'Dynamic
        |comp-walking-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-walking-demo (touch-key)
              let
                  trails $ generate-trails
                container ({})
                  create-list :container
                    {} $ :position ([] 200 0)
                    -> trails $ map-indexed
                      fn (idx trail)
                        [] idx $ graphics
                          {}
                            :position $ [] 0 0
                            :ops $ get-trail-ops trail
                  comp-reset $ [] 0 0
          :examples $ []
          :schema $ :: 'Dynamic
        |expand-directions $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn expand-directions (base)
              []
                add-path base $ [] 0 -1
                add-path base $ [] 0 1
                add-path base $ [] 1 0
                add-path base $ [] -1 0
          :examples $ []
          :schema $ :: 'Dynamic
        |generate-trails $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn generate-trails ()
              reset! *grid $ {}
              let
                  trails $ -> (range 280)
                    map $ fn (x)
                      [] $ rand-point 80
                    distinct
                &doseq (p trails)
                  swap! *grid assoc
                    option:unwrap-or (first p) 0
                    , true
                loop
                    idx 120
                    acc trails
                  if (= 0 idx) acc $ recur (dec idx) (iterate-trails acc)
          :examples $ []
          :schema $ :: 'Dynamic
        |get-trail-ops $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn get-trail-ops (trail)
              let
                  zoom-in $ [] 6 0
                concat
                  []
                    g :move-to $ multiply-path (first trail) zoom-in
                    g :line-style $ {}
                      :color $ rand-int (hslx 0 0 90)
                      :width 2
                      :alpha 1
                  -> trail rest $ map
                    fn (stop)
                      [] :line-to $ multiply-path stop zoom-in
          :examples $ []
          :schema $ :: 'Dynamic
        |iterate-trails $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn iterate-trails (trails)
              -> trails $ map
                fn (trail)
                  let
                      pick-next $ fn (base)
                        let
                            directions $ expand-directions base
                            available $ -> directions
                              filter-not $ fn (x) (get @*grid x)
                          if
                            not $ empty? available
                            let
                                picked $ pick-one available
                              swap! *grid assoc picked true
                              [] picked
                            []
                    let
                        tail-next $ pick-next (last trail)
                        head-next $ pick-next (first trail)
                      concat head-next trail tail-next
          :examples $ []
          :schema $ :: 'Dynamic
        |pick-one $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn pick-one (xs)
              nth xs $ rand-int (count xs)
          :examples $ []
          :schema $ :: 'Dynamic
        |rand-point $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn rand-point (n)
              [] (rand-int n) (rand-int n)
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.walking-demo $ :require
            [] phlox.core :refer $ [] defcomp g hslx rect circle text container graphics create-list hslx
            [] app.util :refer $ [] add-path multiply-path
            [] app.comp.reset :refer $ [] comp-reset
            [] clojure.core.rrb-vector :refer $ [] catvec
            |@calcit/std :refer $ rand rand-int rand-nth
    |app.config $ %{} 'FileEntry
      :defs $ {}
        |site $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def site $ {} (:dev-ui |http://localhost:8100/main-fonts.css) (:release-ui |http://cdn.tiye.me/favored-fonts/main-fonts.css) (:cdn-url |http://cdn.tiye.me/circling-tree/) (:title "|Circling Tree") (:icon |http://cdn.tiye.me/logo/quamolit.png) (:storage-key |circling-tree)
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.config $ :require (|mobile-detect :default mobile-detect)
    |app.main $ %{} 'FileEntry
      :defs $ {}
        |*store $ %{} 'CodeEntry (:doc |)
          :code $ quote (defatom *store schema/store)
          :examples $ []
          :schema $ :: 'Dynamic
        |dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn dispatch! (op)
              when
                not= (nth op 0) :states
                println |dispatch! op
              let
                  op-id $ shortid/generate
                  op-time $ app.util/ffi-date-now
                reset! *store $ updater @*store op op-id op-time
          :examples $ []
          :schema $ :: 'Dynamic
        |main! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn main! () (; js/console.log PIXI)
              -> (new FontFaceObserver "|Josefin Sans") (.load)
                .then $ fn (e) (render-app!)
              add-watch *store :change $ fn (s p) (render-app!)
              ; println |code $ -> @phlox-core/*app .-renderer .-plugins .-interaction .-interactionFrequency
              when mobile? (render-control!) (start-control-loop! 8 on-control-event)
              println "|App Started"
          :examples $ []
          :schema $ :: 'Dynamic
        |reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn reload! () $ if (nil? build-errors)
              do (clear-phlox-caches!) (remove-watch *store :change)
                add-watch *store :change $ fn (store prev) (render-app!)
                render-app!
                when mobile? (replace-control-loop! 8 on-control-event) (render-control!)
                hud! |ok~ |Ok
              hud! |error build-errors
          :examples $ []
          :schema $ :: 'Dynamic
        |render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn render-app! () $ render! (comp-container @*store) dispatch! ({})
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.main $ :require (|pixi.js :as PIXI)
            phlox.core :refer $ render! clear-phlox-caches! on-control-event
            app.comp.container :refer $ comp-container
            app.schema :as schema
            |shortid :as shortid
            app.updater :refer $ updater
            |fontfaceobserver-es :default FontFaceObserver
            phlox.core :as phlox-core
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
            phlox.config :refer $ dev? mobile?
            touch-control.core :refer $ render-control! start-control-loop! replace-control-loop!
    |app.schema $ %{} 'FileEntry
      :defs $ {}
        |store $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def store $ {} (:tab nil)
              :states $ {}
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote (ns app.schema)
    |app.style $ %{} 'FileEntry
      :defs $ {}
        |font-fancy $ %{} 'CodeEntry (:doc |)
          :code $ quote (def font-fancy "|Josefin Sans, Helvetica Neue, sans-serif")
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote (ns app.style)
    |app.updater $ %{} 'FileEntry
      :defs $ {}
        |updater $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn updater (store op op-id op-time)
              tag-match op
                (:tab t) (assoc store :tab t)
                (:touch t) (assoc store :touch-key t)
                (:states cursor s) (update-states store cursor s)
                _ $ do (eprintln "|unknown op" op) store
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.updater $ :require
            [] phlox.cursor :refer $ [] update-states
    |app.util $ %{} 'FileEntry
      :defs $ {}
        |add-path $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn add-path (p1 p2)
              let-sugar
                    [] a b
                    , p1
                  ([] x y) p2
                [] (+ a x) (+ b y)
          :examples $ []
          :schema $ :: 'Dynamic
        |divide-path $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn divide-path (p1 p2)
              let-sugar
                    [] x y
                    , p1
                  ([] a b) p2
                  inverted $ / 1
                    + (* a a) (* b b)
                []
                  * inverted $ + (* x a) (* y b)
                  * inverted $ - (* y a) (* x b)
          :examples $ []
          :schema $ :: 'Dynamic
        |divide-x $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn divide-x (point x)
              []
                / (first point) x
                / (last point) x
          :examples $ []
          :schema $ :: 'Dynamic
        |ffi-date-now $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn ffi-date-now () $ unsafe-coerce
              .!now $ unsafe-coerce js/Date JsObject
              , Number
          :examples $ []
          :schema $ :: 'Dynamic
        |ffi-e $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def ffi-e $ unsafe-coerce js/Math.E Number
          :examples $ []
          :schema $ :: 'Dynamic
        |ffi-performance-now $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn ffi-performance-now () $ unsafe-coerce js/performance.now Number
          :examples $ []
          :schema $ :: 'Dynamic
        |ffi-pow $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn ffi-pow (base exponent)
              unsafe-coerce (js/Math.pow base exponent) Number
          :examples $ []
          :schema $ :: 'Dynamic
        |ffi-request-fullscreen $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn ffi-request-fullscreen (target)
              .!requestFullscreen $ unsafe-coerce target JsObject
          :examples $ []
          :schema $ :: 'Dynamic
        |ffi-round $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn ffi-round (value)
              unsafe-coerce (js/Math.round value) Number
          :examples $ []
          :schema $ :: 'Dynamic
        |first-list $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn first-list (xs)
              option:unwrap-or (first xs) (repeat nil 0)
          :examples $ []
          :schema $ :: 'Dynamic
        |invert-y $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn invert-y (pair)
              let[] (x y) pair $ [] x (negate y)
          :examples $ []
          :schema $ :: 'Dynamic
        |last-list $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn last-list (xs)
              option:unwrap-or (last xs) (repeat nil 0)
          :examples $ []
          :schema $ :: 'Dynamic
        |multiply-path $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn multiply-path (p1 p2)
              let-sugar
                    [] a b
                    , p1
                  ([] x y) p2
                []
                  - (* a x) (* b y)
                  + (* a y) (* b x)
          :examples $ []
          :schema $ :: 'Dynamic
        |rand-color $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn rand-color () $ rand-int 0xffffff
          :examples $ []
          :schema $ :: 'Dynamic
        |rand-nth $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn rand-nth (xs)
              let
                  n $ rand-int (count xs)
                nth xs n
          :examples $ []
          :schema $ :: 'Dynamic
        |rand-point $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn rand-point (n ? m)
              let
                  m $ or m n
                []
                  -
                    ffi-round $ * 0.2 n
                    rand-int n
                  -
                    ffi-round $ * 0.2 m
                    rand-int m
          :examples $ []
          :schema $ :: 'Dynamic
        |rough-size $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn rough-size (pair)
              let[] (x y) pair $ + (phlox.core/ffi-abs x) (phlox.core/ffi-abs y)
          :examples $ []
          :schema $ :: 'Dynamic
        |subtract-path $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn subtract-path (p1 p2)
              let-sugar
                    [] a b
                    , p1
                  ([] x y) p2
                [] (- a x) (- b y)
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.util $ :require
            |@calcit/std :refer $ rand rand-int
