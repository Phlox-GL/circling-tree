
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!)
    :modules $ [] |memof/ |lilac/ |respo.calcit/ |respo-ui.calcit/ |phlox/ |touch-control/
    :version nil
  :entries $ {}
  :files $ {}
    |app.comp.oscillo-demo $ {}
      :ns $ quote
        ns app.comp.oscillo-demo $ :require
          [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
          [] app.util :refer $ [] rand-point rand-color
          [] phlox.comp.button :refer $ [] comp-button
          [] phlox.comp.slider :refer $ [] comp-slider
          "\"@calcit/std" :refer $ rand rand-int
      :defs $ {}
        |comp-oscillo-control $ quote
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
                          d! (:cursor states)
                            assoc state param $ case-default param (js/Math.max 0 value)
                              :m $ js/Math.max 1 (js/Math.round value)
                              :n $ js/Math.max 1 (js/Math.round value)
                              :step $ js/Math.max 1 (js/Math.round value)
              comp-button $ {} (:text "\"Random")
                :position $ [] 580 0
                :on-pointertap $ fn (e d!)
                  d! (:cursor states)
                    {}
                      :m $ rand-int 40
                      :n $ rand-int 40
                      :step 500
                      :unit 0.01
        |initial-state $ quote
          def initial-state $ {} (:step 1000) (:unit 0.01) (:m 13) (:n 3)
        |comp-oscillo-demo $ quote
          defcomp comp-oscillo-demo (states)
            let
                cursor $ :cursor states
                state $ or (:data states) initial-state
              container ({})
                graphics $ {}
                  :position $ [] 400 360
                  :ops $ let
                      step $ :step state
                      r 200
                      m $ :m state
                      n $ :n state
                      unit $ :unit state
                      trail $ -> (range step)
                        map $ fn (idx)
                          let
                              t $ * idx unit
                            []
                              * r $ js/Math.cos (* m t)
                              * r $ js/Math.sin (* n t)
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
        |get-round? $ quote
          defn get-round? (param)
            case param (:unit false) (do true)
    |app.comp.container $ {}
      :ns $ quote
        ns app.comp.container $ :require
          [] phlox.core :refer $ [] defcomp >> hslx rect circle text container graphics create-list hslx
          [] app.comp.sun-demo :refer $ [] comp-sun-demo
          [] app.comp.circle-demo :refer $ [] comp-circle-demo
          [] app.comp.tree-demo :refer $ [] comp-tree-demo
          [] app.comp.walking-demo :refer $ [] comp-walking-demo
          [] app.comp.grow-demo :refer $ [] comp-grow-demo
          [] app.comp.rotate-demo :refer $ [] comp-rotate-demo
          [] app.comp.rects-demo :refer $ [] comp-rects-demo
          [] app.comp.chars-demo :refer $ [] comp-chars-demo
          [] app.comp.bezier-demo :refer $ [] comp-bezier-demo
          [] app.comp.cycloid-demo :refer $ [] comp-cycloid-demo
          [] app.comp.chord-demo :refer $ [] comp-chord-demo
          [] app.comp.oscillo-demo :refer $ [] comp-oscillo-demo
          [] app.comp.geocentric-demo :refer $ [] comp-geocentric-demo
          [] app.comp.snowflake-demo :refer $ [] comp-snowflake-demo
          [] app.comp.harmono-demo :refer $ [] comp-harmono-demo
          [] app.comp.satellite-demo :refer $ [] comp-satellite-demo
          [] app.style :as style
          [] clojure.string :as string
      :defs $ {}
        |comp-container $ quote
          defcomp comp-container (store)
            let
                tab $ :tab store
                states $ :states store
                touch-key $ :touch-key store
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
                      :text $ str "\"Unknown " tab
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
                    :pointertap $ fn (e d!) (js/document.body.requestFullscreen)
        |tabs $ quote
          def tabs $ [] :sun :circle :rects :walking :grow :chars :cycloid :chord :oscillo :geocentric :rotate :bezier :tree :snowflake :harmono :satellite
        |comp-tab $ quote
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
        |cap-name $ quote
          defn cap-name (x)
            str
              .!toUpperCase $ first x
              .slice x 1
    |app.schema $ {}
      :ns $ quote (ns app.schema)
      :defs $ {}
        |store $ quote
          def store $ {} (:tab nil)
            :states $ {}
    |app.comp.tree-demo $ {}
      :ns $ quote
        ns app.comp.tree-demo $ :require
          [] phlox.core :refer $ [] defcomp >> g hslx rect circle text container graphics create-list hslx
          [] app.util :refer $ [] add-path multiply-path subtract-path divide-path rough-size
          [] phlox.comp.drag-point :refer $ [] comp-drag-point
      :defs $ {}
        |comp-tree-demo $ quote
          defcomp comp-tree-demo (states)
            let
                cursor $ :cursor states
                state $ or (:data states)
                  {}
                    :p1 $ [] 0.7 0.2
                    :p2 $ [] 0.84 0.15
                    :p0 $ [] 3 -80
                p0 $ :p0 state
                base $ subtract-path ([] 0 0) p0
                factor-1 $ divide-path (:p1 state) base
                factor-2 $ divide-path (:p2 state) base
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
                    :position $ :p1 state
                    :radius 10
                    :fill $ hslx 200 80 60
                    :alpha 0.4
                    :on-change $ fn (position d!)
                      d! cursor $ assoc state :p1 position
                comp-drag-point (>> states :p2)
                  {}
                    :position $ :p2 state
                    :title "\"end"
                    :radius 10
                    :alpha 0.4
                    :fill $ hslx 200 80 60
                    :on-change $ fn (position d!)
                      d! cursor $ assoc state :p2 position
                comp-drag-point (>> states :p0)
                  {}
                    :position $ :p0 state
                    :title "\"from"
                    :radius 10
                    :alpha 0.5
                    :fill $ hslx 100 90 80
                    :on-change $ fn (position d!)
                      d! cursor $ assoc state :p0 position
        |generate-branches $ quote
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
        |should-shrink? $ quote
          defn should-shrink? (level)
            cond
                < level 4
                , false
              (> level 8) true
              :else $ > (rand 2) 1.4
    |app.updater $ {}
      :ns $ quote
        ns app.updater $ :require
          [] phlox.cursor :refer $ [] update-states
      :defs $ {}
        |updater $ quote
          defn updater (store op op-data op-id op-time)
            case-default op
              do (println "\"unknown op" op op-data) store
              :tab $ assoc store :tab op-data
              :touch $ assoc store :touch-key op-id
              :states $ update-states store op-data
    |app.comp.geocentric-demo $ {}
      :ns $ quote
        ns app.comp.geocentric-demo $ :require
          [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
          [] app.util :refer $ [] rand-point rand-color add-path
          [] phlox.comp.button :refer $ [] comp-button
          [] phlox.comp.slider :refer $ [] comp-slider
          "\"@calcit/std" :refer $ rand rand-int
      :defs $ {}
        |comp-geocentric-control $ quote
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
                          d! (:cursor states)
                            assoc state param $ case-default param value
                              :r2 $ js/Math.max 1 (js/Math.round value)
                              :v2 $ js/Math.max 1 (js/Math.round value)
                              :r3 $ js/Math.max 1 (js/Math.round value)
                              :v3 $ js/Math.max 1 (js/Math.round value)
                              :steps $ js/Math.round value
              comp-button $ {} (:text "\"Random")
                :position $ [] 580 40
                :on-pointertap $ fn (e d!)
                  d! (:cursor states)
                    {}
                      :r2 $ rand-int 200
                      :v2 $ rand 3
                      :r3 $ rand-int 200
                      :v3 $ rand 3
                      :steps 4000
                      :step 0.1
        |initial-state $ quote
          def initial-state $ {} (:r2 100) (:r3 16) (:v2 30) (:v3 260) (:steps 2000) (:step 0.002) (:selected :r2)
        |comp-geocentric-demo $ quote
          defcomp comp-geocentric-demo (states)
            let
                state $ or (:data states) initial-state
              container ({})
                graphics $ {}
                  :position $ [] 400 360
                  :ops $ let
                      steps $ :steps state
                      step $ :step state
                      r2 $ :r2 state
                      r3 $ :r3 state
                      trail $ -> (range steps)
                        map $ fn (idx)
                          let
                              t $ * idx step
                            add-path
                              add-path
                                []
                                  * 200 $ js/Math.cos t
                                  * 200 $ js/Math.sin t
                                []
                                  * r2 $ js/Math.cos
                                    * t $ :v2 state
                                  * r2 $ js/Math.sin
                                    * t $ :v2 state
                              []
                                * r3 $ js/Math.cos
                                  * t $ :v3 state
                                * r3 $ js/Math.sin
                                  * t $ :v3 state
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
        |get-unit $ quote
          defn get-unit (param)
            case-default param 1 (:r2 1) (:r3 0.5) (:v2 0.2) (:v3 0.2) (:steps 100) (:step 0.001)
    |app.comp.chord-demo $ {}
      :ns $ quote
        ns app.comp.chord-demo $ :require
          [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
          [] app.comp.reset :refer $ [] comp-reset
          [] app.util :refer $ [] rand-point rand-color
          [] phlox.comp.slider :refer $ [] comp-slider
          "\"@calcit/std" :refer $ rand rand-int
      :defs $ {}
        |shuffle $ quote
          defn shuffle (xs) (js/console.warn "\"TODO shuffle" xs) xs
        |generate-ops $ quote
          defn generate-ops (size)
            let
                r 320
                shares $ + 2 size
              -> (range shares) shuffle $ mapcat
                fn (idx)
                  let
                      t $ * 2 js/Math.PI idx (/ 1 shares)
                      t2 $ rand (* 2 js/Math.PI)
                      color $ hslx
                        * 180 t $ / 1 js/Math.PI
                        , 100 60
                    []
                      g :move-to $ []
                        * r $ js/Math.cos t
                        * r $ js/Math.sin t
                      g :line-style $ {} (:color color) (:width 2) (:alpha 0.8)
                      g :quadratic-to $ {}
                        :p1 $ [] 0 0
                        :to-p $ []
                          * r $ js/Math.cos t2
                          * r $ js/Math.sin t2
                      g :line-style $ {} (:color color) (:width 0) (:alpha 0)
                      g :arc $ {}
                        :center $ [] 0 0
                        :radius r
                        :angle $ [] t2 t
                        :anticlockwise? $ <
                          js/Math.abs $ - t t2
                          , js/Math.PI
        |comp-chord-demo $ quote
          defcomp comp-chord-demo (states)
            let
                cursor $ :cursor states
                state $ or (:data states)
                  {} $ :size 20
              container ({})
                graphics $ {}
                  :position $ [] 200 320
                  :ops $ generate-ops (:size state)
                comp-slider (>> states :size)
                  {}
                    :value $ :size state
                    :title "\"Size"
                    :unit 0.1
                    :round? true
                    :on-change $ fn (n d!)
                      d! cursor $ assoc state :size
                        js/Math.min 300 $ js/Math.max (js/Math.round n) 4
    |app.comp.satellite-demo $ {}
      :ns $ quote
        ns app.comp.satellite-demo $ :require
          [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
          [] app.comp.reset :refer $ [] comp-reset
          [] app.util :refer $ [] rand-point
          [] phlox.comp.slider :refer $ [] comp-slider
          [] phlox.comp.button :refer $ [] comp-button
          "\"@calcit/std" :refer $ rand rand-int
      :defs $ {}
        |comp-number-controls $ quote
          defcomp comp-number-controls (state states)
            let
                cursor $ :cursor states
                selected $ get state :selected
                segment $ get-in state ([] :segments selected)
              container ({})
                comp-slider (>> states :unit)
                  {}
                    :value $ :unit state
                    :unit 0.1
                    :min 0
                    :title "\"unit"
                    :on-change $ fn (result d!)
                      d! cursor $ assoc state :unit result
                comp-slider (>> states :selected)
                  {}
                    :value $ :selected state
                    :position $ [] 140 0
                    :unit 0.1
                    :round? true
                    :min 0
                    :max $ dec
                      count $ :segments state
                    :title "\"selected"
                    :on-change $ fn (result d!)
                      d! cursor $ assoc state :selected result
                comp-slider (>> states :from)
                  {}
                    :value $ get-in state
                      [] :segments (:selected state) 0
                    :position $ [] 280 0
                    :unit 1
                    :round? true
                    :title "\"from angle"
                    :on-change $ fn (result d!)
                      d! cursor $ assoc-in state
                        [] :segments (:selected state) 0
                        , result
                comp-slider (>> states :to)
                  {}
                    :value $ get-in state
                      [] :segments (:selected state) 1
                    :position $ [] 420 0
                    :unit 1
                    :round? true
                    :min 0
                    :max 360
                    :title "\"range"
                    :on-change $ fn (result d!)
                      d! cursor $ assoc-in state
                        [] :segments (:selected state) 1
                        , result
                comp-button $ {} (:text "\"Add")
                  :position $ [] 600 0
                  :on $ {}
                    :pointertap $ fn (e d!)
                      d! cursor $ -> state
                        update :segments $ fn (xs)
                          conj xs $ [] (rand-int 360) (rand-int 360)
                        assoc :selected $ count (:segments state)
                comp-button $ {} (:text "\"Remove")
                  :position $ [] 660 0
                  :on $ {}
                    :pointertap $ fn (e d!)
                      d! cursor $ -> state
                        update :segments $ fn (xs)
                          if
                            < (count xs) 2
                            , xs $ butlast xs
                        assoc :selected 0
        |comp-satellite-demo $ quote
          defcomp comp-satellite-demo (states)
            let
                cursor $ :cursor states
                state $ or (:data states)
                  {} (:unit 20)
                    :segments $ [] ([] 0 100) ([] 50 200) ([] 100 180)
                    :selected 0
                ratio $ * js/Math.PI (/ 1 180)
                rad $ fn (x) (* x ratio)
              container ({}) (comp-number-controls state states)
                create-list :container
                  {} $ :position ([] 400 400)
                  -> (:segments state)
                    map-indexed $ fn (idx segment)
                      [] idx $ let
                          r $ + 10
                            * idx $ :unit state
                        graphics $ {}
                          :ops $ []
                            g :line-style $ {}
                              :color $ if
                                = idx $ :selected state
                                hslx 0 0 100
                                hslx 20 80 70
                              :width $ if
                                = idx $ :selected state
                                , 2 2
                              :alpha 1
                            ; g :begin-fill $ {}
                              :color $ hslx 20 80 70
                            g :arc $ {}
                              :center $ let
                                  th $ first segment
                                []
                                  * r $ js/Math.cos (rad th)
                                  * r $ js/Math.sin (rad th)
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
                                  * r $ js/Math.cos (rad th)
                                  * r $ js/Math.sin (rad th)
                              :radius 4
                              :angle $ [] 0 360
                            g :end-fill nil
    |app.comp.sun-demo $ {}
      :ns $ quote
        ns app.comp.sun-demo $ :require
          [] phlox.core :refer $ [] defcomp g hslx rect circle text container graphics create-list hslx
          [] app.comp.reset :refer $ [] comp-reset
      :defs $ {}
        |comp-sun-demo $ quote
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
                        :rotation $ * 0.010 js/Math.PI x
                        :ops $ generate-line-ops
        |generate-line-ops $ quote
          defn generate-line-ops () $ let
              x0 2
              ops $ []
                g :move-to $ []
                  + x0 $ * 400 (js/Math.random)
                  , 0
            loop
                acc ops
                x x0
              if (> x 300) acc $ let
                  x1 $ + x
                    * 80 $ js/Math.random
                  x2 $ + x1
                    + 4 $ * 8 (js/Math.random)
                recur
                  conj acc
                    g :line-style $ {}
                      :color $ * (js/Math.random) (hslx 0 0 100)
                      :width $ if (< x2 160) 2 3
                      :alpha $ if (< x2 80) 0.2 0.9
                    g :line-to $ [] x1 0
                    g :move-to $ [] x2 0
                  , x2
    |app.comp.cycloid-demo $ {}
      :ns $ quote
        ns app.comp.cycloid-demo $ :require
          [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
          [] app.comp.reset :refer $ [] comp-reset
          [] app.util :refer $ [] rand-point add-path subtract-path multiply-path
          [] phlox.comp.button :refer $ [] comp-button
          [] phlox.comp.slider :refer $ [] comp-slider
          [] phlox.comp.switch :refer $ [] comp-switch
          "\"@calcit/std" :refer $ rand rand-int
      :defs $ {}
        |round-value $ quote
          defn round-value (v param)
            case-default param v $ :steps
              js/Math.max 0 $ js/Math.round v
        |polar-point $ quote
          defn polar-point (r theta)
            []
              * r $ js/Math.cos theta
              * r $ js/Math.sin theta
        |zero? $ quote
          defn zero? (x) (= x 0)
        |comp-numbers-control $ quote
          defcomp comp-numbers-control (state states)
            let
                cursor $ :cursor states
                params $ [] :r1 :r2 :r3 :r4 :r5 :steps :v
                is-round? $ :round? state
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
                comp-switch $ {} (:value is-round?) (:title "\"Round value?")
                  :position $ [] 0 100
                  :on-change $ fn (e d!)
                    d! cursor $ update state :round? not
                comp-button $ {} (:text "\"rand2")
                  :position $ [] 100 80
                  :on-pointertap $ fn (e d!)
                    d! cursor $ merge state
                      {}
                        :r1 $ rand-value
                        :r2 $ rand-value
                        :r3 0
                        :r4 0
                        :r5 0
                comp-button $ {} (:text "\"rand3")
                  :position $ [] 240 80
                  :on-pointertap $ fn (e d!)
                    d! cursor $ merge state
                      {}
                        :r1 $ rand-value
                        :r2 $ rand-value
                        :r3 $ rand-value
                        :r4 0
                        :r5 0
                comp-button $ {} (:text "\"rand4")
                  :position $ [] 380 80
                  :on-pointertap $ fn (e d!)
                    d! cursor $ merge state
                      {}
                        :r1 $ rand-value
                        :r2 $ rand-value
                        :r3 $ rand-value
                        :r4 $ rand-value
                        :r5 0
                comp-button $ {} (:text "\"rand5")
                  :position $ [] 520 80
                  :on-pointertap $ fn (e d!)
                    d! cursor $ merge state
                      {}
                        :r1 $ rand-value
                        :r2 $ rand-value
                        :r3 $ rand-value
                        :r4 $ rand-value
                        :r5 $ rand-value
        |get-round? $ quote
          defn get-round? (param)
            case param (:r1 true) (:r2 true) (:r3 true) (:r4 true) (:r5 true) (:steps true) (do false)
        |get-unit $ quote
          defn get-unit (param)
            case-default param 1 (:r1 0.2) (:r2 0.1) (:r3 0.04) (:r4 0.04) (:r5 0.04) (:steps 20) (:v 0.001)
        |comp-cycloid-demo $ quote
          defcomp comp-cycloid-demo (states)
            let
                cursor $ :cursor states
                state $ or (:data states)
                  {} (:r1 312) (:r2 80) (:r3 96) (:r4 20) (:r5 8) (:steps 2000) (:v 0.11) (:round? true)
              container ({}) (comp-numbers-control state states)
                graphics $ {}
                  :position $ [] 400 400
                  :ops $ let
                      r1 $ :r1 state
                      r2 $ :r2 state
                      r3 $ :r3 state
                      r4 $ :r4 state
                      r5 $ :r5 state
                      trail $ ->
                        range $ :steps state
                        map $ fn (idx)
                          let
                              t $ * idx (:v state)
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
    |app.comp.circle-demo $ {}
      :ns $ quote
        ns app.comp.circle-demo $ :require
          [] phlox.core :refer $ [] defcomp hslx rect circle text container graphics create-list hslx g
          [] app.comp.reset :refer $ [] comp-reset
          "\"@calcit/std" :refer $ rand rand-int
      :defs $ {}
        |comp-circle-demo $ quote
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
        |generate-circle-ops $ quote
          defn generate-circle-ops (idx)
            loop
                angle 0
                acc $ []
              if
                > angle $ + js/Math.PI -0.3 (rand 1.4)
                , acc $ let
                    ratio $ / 1 (inc idx)
                    a1 $ + angle (* 0.4 ratio)
                    a2 $ + a1
                      * 6 ratio $ js/Math.random
                    r0 $ / 180 js/Math.PI
                  recur
                    + a2 $ * 0.2 ratio
                    conj acc
                      g :line-style $ {}
                        :color $ * (js/Math.random) (hslx 0 0 100)
                        :width 6
                        :alpha 0
                      g :arc $ {}
                        :center $ [] 0 0
                        :radius $ * 8 idx
                        :angle $ [] (* r0 angle) (* r0 a1)
                        :anticlockwise? false
                      g :line-style $ {}
                        :color $ * (js/Math.random) (hslx 0 0 100)
                        :width 4
                        :alpha 1
                      g :arc $ {}
                        :center $ [] 0 0
                        :radius $ * 8 idx
                        :angle $ [] (* r0 a1) (* r0 a2)
                        :anticlockwise? false
    |app.comp.rects-demo $ {}
      :ns $ quote
        ns app.comp.rects-demo $ :require
          [] phlox.core :refer $ [] defcomp hslx g rect circle text container graphics create-list hslx
          [] app.comp.reset :refer $ [] comp-reset
          [] app.util :refer $ [] rand-point
          "\"@calcit/std" :refer $ rand rand-int
      :defs $ {}
        |comp-rects-demo $ quote
          defcomp comp-rects-demo (touch-key)
            container ({})
              create-list :container
                {} $ :position ([] 40 40)
                -> (range 10)
                  mapcat $ fn (x)
                    -> (range 10)
                      map $ fn (y)
                        [] (str x "\"+" y)
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
    |app.style $ {}
      :ns $ quote (ns app.style)
      :defs $ {}
        |font-fancy $ quote (def font-fancy "\"Josefin Sans, Helvetica Neue, sans-serif")
    |app.comp.reset $ {}
      :ns $ quote
        ns app.comp.reset $ :require
          [] phlox.core :refer $ [] defcomp hslx rect circle text container graphics create-list hslx
          [] app.style :as style
      :defs $ {}
        |comp-reset $ quote
          defcomp comp-reset (position)
            container
              {} $ :position position
              rect $ {}
                :position $ [] 0 0
                :size $ [] 80 40
                :fill $ hslx 0 0 40
                :on $ {}
                  :pointertap $ fn (e d!) (d! :touch nil)
              text $ {} (:text "\"Refresh")
                :position $ [] 8 6
                :style $ {} (:font-family style/font-fancy)
                  :fill $ hslx 0 0 100
                  :font-size 20
    |app.comp.harmono-demo $ {}
      :ns $ quote
        ns app.comp.harmono-demo $ :require
          [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
          [] app.util :refer $ [] rand-point rand-color add-path multiply-path
          [] phlox.comp.slider :refer $ [] comp-slider
          [] phlox.comp.drag-point :refer $ [] comp-drag-point
          "\"@calcit/std" :refer $ rand
      :defs $ {}
        |render-points $ quote
          defn render-points (cursor states state controls)
            create-list :container ({})
              -> controls $ map-indexed
                fn (idx control)
                  [] idx $ comp-drag-point
                    >> states $ str "\"apmplitude:" idx
                    {}
                      :position $ :amplitude control
                      :on-change $ fn (v d!)
                        d! cursor $ assoc-in state ([] :controls idx :amplitude) v
        |comp-harmono-demo $ quote
          defcomp comp-harmono-demo (states)
            let
                cursor $ :cursor states
                state $ or (:data states)
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
                controls $ :controls state
                trail $ gen-trail controls (:steps state) (:base state)
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
        |gen-trail $ quote
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
                              js/Math.sin $ +
                                * t $ :frequency control
                                :phase control
                              js/Math.pow js/Math.E $ * -1 (:damping control) t
                            , 0
                          :amplitude control
                      reduce ([] 0 0) add-path
                  , final-point
        |render-controls $ quote
          defn render-controls (cursor states state controls)
            container
              {} $ :position ([] 0 -340)
              comp-slider (>> states :steps)
                {}
                  :position $ [] 0 0
                  :value $ :steps state
                  :unit 10
                  :round? true
                  :min 0
                  :title "\"steps"
                  :on-change $ fn (v d!)
                    d! cursor $ assoc state :steps v
              comp-slider (>> states :base)
                {}
                  :position $ [] 140 0
                  :value $ :base state
                  :unit 0.001
                  :round? false
                  :min 0
                  :title "\"base"
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
                        >> states $ str "\"frequency:" idx
                        {}
                          :position $ [] 140 0
                          :value $ :frequency control
                          :unit 0.1
                          :round? true
                          :min 0
                          :title "\"frequency"
                          :on-change $ fn (v d!)
                            d! cursor $ assoc-in state ([] :controls idx :frequency) v
                      comp-slider
                        >> states $ str "\"phase:" idx
                        {}
                          :position $ [] 140 50
                          :value $ :phase control
                          :unit 0.1
                          :round? false
                          :min 0
                          :title "\"phase"
                          :on-change $ fn (v d!)
                            d! cursor $ assoc-in state ([] :controls idx :phase) v
                      comp-slider
                        >> states $ str "\"damping:" idx
                        {}
                          :position $ [] 140 100
                          :value $ :damping control
                          :unit 0.01
                          :round? false
                          :min 0
                          :title "\"damping"
                          :on-change $ fn (v d!)
                            d! cursor $ assoc-in state ([] :controls idx :damping) v
    |app.main $ {}
      :ns $ quote
        ns app.main $ :require ([] "\"pixi.js" :as PIXI)
          [] phlox.core :refer $ [] render! clear-phlox-caches! update-viewer!
          [] app.comp.container :refer $ [] comp-container
          [] app.schema :as schema
          [] "\"shortid" :as shortid
          [] app.updater :refer $ [] updater
          [] "\"fontfaceobserver-es" :default FontFaceObserver
          [] phlox.core :as phlox-core
          "\"./calcit.build-errors" :default build-errors
          "\"bottom-tip" :default hud!
          app.config :refer $ dev? mobile?
          touch-control.core :refer $ render-control! start-control-loop! replace-control-loop!
      :defs $ {}
        |render-app! $ quote
          defn render-app! () $ render! (comp-container @*store) dispatch! ({})
        |main! $ quote
          defn main! () (; js/console.log PIXI)
            -> (new FontFaceObserver "\"Josefin Sans") (.load)
              .then $ fn (e) (render-app!)
            add-watch *store :change $ fn (s p) (render-app!)
            ; println "\"code" $ -> @phlox-core/*app .-renderer .-plugins .-interaction .-interactionFrequency
            when mobile? (render-control!) (start-control-loop! 8 on-control-event)
            println "\"App Started"
        |*store $ quote (defatom *store schema/store)
        |dispatch! $ quote
          defn dispatch! (op op-data)
            when (not= op :states) (println "\"dispatch!" op op-data)
            let
                op-id $ shortid/generate
                op-time $ .!now js/Date
              reset! *store $ updater @*store op op-data op-id op-time
        |reload! $ quote
          defn reload! () $ if (nil? build-errors)
            do (clear-phlox-caches!) (remove-watch *store :change)
              add-watch *store :change $ fn (store prev) (render-app!)
              render-app!
              when mobile? (replace-control-loop! 8 on-control-event) (render-control!)
              hud! "\"ok~" "\"Ok"
            hud! "\"error" build-errors
        |on-control-event $ quote
          defn on-control-event (elapsed states delta)
            let
                move $ :left-move states
                scales $ :right-move delta
              update-viewer! move $ nth scales 1
    |app.util $ {}
      :ns $ quote
        ns app.util $ :require
          "\"@calcit/std" :refer $ rand rand-int
      :defs $ {}
        |divide-path $ quote
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
        |add-path $ quote
          defn add-path (p1 p2)
            let-sugar
                  [] a b
                  , p1
                ([] x y) p2
              [] (+ a x) (+ b y)
        |rough-size $ quote
          defn rough-size (pair)
            let[] (x y) pair $ + (js/Math.abs x) (js/Math.abs y)
        |rand-nth $ quote
          defn rand-nth (xs)
            let
                n $ rand-int (count xs)
              nth xs n
        |rand-color $ quote
          defn rand-color () $ rand-int 0xffffff
        |rand-point $ quote
          defn rand-point (n ? m)
            let
                m $ or m n
              []
                -
                  js/Math.round $ * 0.2 n
                  rand-int n
                -
                  js/Math.round $ * 0.2 m
                  rand-int m
        |divide-x $ quote
          defn divide-x (point x)
            []
              / (first point) x
              / (last point) x
        |invert-y $ quote
          defn invert-y (pair)
            let[] (x y) pair $ [] x (negate y)
        |multiply-path $ quote
          defn multiply-path (p1 p2)
            let-sugar
                  [] a b
                  , p1
                ([] x y) p2
              []
                - (* a x) (* b y)
                + (* a y) (* b x)
        |subtract-path $ quote
          defn subtract-path (p1 p2)
            let-sugar
                  [] a b
                  , p1
                ([] x y) p2
              [] (- a x) (- b y)
    |app.comp.walking-demo $ {}
      :ns $ quote
        ns app.comp.walking-demo $ :require
          [] phlox.core :refer $ [] defcomp g hslx rect circle text container graphics create-list hslx
          [] app.util :refer $ [] add-path multiply-path
          [] app.comp.reset :refer $ [] comp-reset
          [] clojure.core.rrb-vector :refer $ [] catvec
          "\"@calcit/std" :refer $ rand rand-int rand-nth
      :defs $ {}
        |generate-trails $ quote
          defn generate-trails ()
            reset! *grid $ {}
            let
                trails $ -> (range 280)
                  map $ fn (x)
                    [] $ rand-point 80
                  .distinct
              &doseq (p trails)
                swap! *grid assoc (first p) true
              loop
                  idx 120
                  acc trails
                if (= 0 idx) acc $ recur (dec idx) (iterate-trails acc)
        |get-trail-ops $ quote
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
        |pick-one $ quote
          defn pick-one (xs)
            nth xs $ rand-int (count xs)
        |comp-walking-demo $ quote
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
        |*grid $ quote
          defatom *grid $ {}
        |expand-directions $ quote
          defn expand-directions (base)
            []
              add-path base $ [] 0 -1
              add-path base $ [] 0 1
              add-path base $ [] 1 0
              add-path base $ [] -1 0
        |rand-point $ quote
          defn rand-point (n)
            [] (rand-int n) (rand-int n)
        |iterate-trails $ quote
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
    |app.comp.chars-demo $ {}
      :ns $ quote
        ns app.comp.chars-demo $ :require
          [] phlox.core :refer $ [] defcomp hslx g rect circle text container graphics create-list hslx
          [] app.comp.reset :refer $ [] comp-reset
          [] app.util :refer $ [] rand-point rand-nth
          [] app.style :as style
          "\"@calcit/std" :refer $ rand rand-int
      :defs $ {}
        |comp-char $ quote
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
                        [] (str x "\"+" y)
                          container
                            {} $ :position
                              [] (* x 10) (* y 10)
                            comp-stroke touch-key kind
        |slash-strokes $ quote
          def slash-strokes $ []
            []
              g :move-to $ [] 0 0
              g :line-to $ [] 10 10
            []
              g :move-to $ [] 10 0
              g :line-to $ [] 0 10
            []
        |comp-chars-demo $ quote
          defcomp comp-chars-demo (touch-key)
            container ({})
              create-list :container
                {} $ :position ([] 0 0)
                -> (range 10)
                  mapcat $ fn (y)
                    -> (range 10)
                      map $ fn (x)
                        [] (str x "\"+" y)
                          container
                            {} $ :position
                              [] (* x 54) (* y 54)
                            comp-char touch-key $ rand-int 6
              comp-reset $ [] -140 40
        |straight-strokes $ quote
          def straight-strokes $ []
            []
              g :move-to $ [] 5 0
              g :line-to $ [] 5 10
            []
              g :move-to $ [] 0 5
              g :line-to $ [] 10 5
            []
        |dot-strokes $ quote
          def dot-strokes $ []
            []
              g :move-to $ [] 4 5
              g :arc $ {}
                :center $ [] 5 5
                :radius 1
                :angle $ [] (- 0 js/Math.PI) js/Math.PI
              g :close-path nil
            []
              g :move-to $ [] 0 5
              g :arc $ {}
                :center $ [] 5 5
                :radius 4
                :angle $ [] (- 0 js/Math.PI) js/Math.PI
              g :close-path nil
        |comp-stroke $ quote
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
        |curve-strokes $ quote
          def curve-strokes $ []
            []
              g :move-to $ [] 0 0
              g :arc $ {}
                :center $ [] 0 10
                :radius 10
                :angle $ [] (* -0.5 js/Math.PI) 0
            []
              g :move-to $ [] 10 0
              g :arc $ {}
                :center $ [] 0 0
                :radius 10
                :angle $ [] 0 (* 0.5 js/Math.PI)
            []
              g :move-to $ [] 10 10
              g :arc $ {}
                :center $ [] 10 0
                :radius 10
                :angle $ [] (* 0.5 js/Math.PI) js/Math.PI
            []
              g :move-to $ [] 0 10
              g :arc $ {}
                :center $ [] 10 10
                :radius 10
                :angle $ [] js/Math.PI (* 1.5 js/Math.PI)
    |app.comp.bezier-demo $ {}
      :ns $ quote
        ns app.comp.bezier-demo $ :require
          [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
          [] app.comp.reset :refer $ [] comp-reset
          [] app.util :refer $ [] rand-point add-path subtract-path divide-x multiply-path
          [] phlox.comp.drag-point :refer $ [] comp-drag-point
          [] phlox.comp.slider :refer $ [] comp-slider
      :defs $ {}
        |gen-trail $ quote
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
        |comp-bezier-demo $ quote
          defcomp comp-bezier-demo (states)
            let
                cursor $ :cursor states
                state $ or (:data states)
                  {}
                    :points $ [] ([] 40 100) ([] 200 100) ([] 200 400) ([] 40 400)
                    :n 80
              container ({})
                graphics $ {}
                  :position $ [] 0 0
                  :ops $ let-sugar
                        [] p1 p2 q1 q2
                        :points state
                      n $ :n state
                    gen-trail p1 p2 q1 q2 n
                create-list :container ({})
                  -> (:points state)
                    map-indexed $ fn (idx point)
                      [] idx $ comp-drag-point (>> states idx)
                        {} (:position point)
                          :on-change $ fn (value d!)
                            d! cursor $ assoc-in state ([] :points idx) value
                comp-slider (>> states :n)
                  {} (:title "\"n")
                    :position $ [] 0 -40
                    :value $ :n state
                    :unit 0.3
                    :round? true
                    :on-change $ fn (value d!)
                      d! cursor $ assoc state :n
                        js/Math.max 1 $ js/Math.round value
    |app.comp.grow-demo $ {}
      :ns $ quote
        ns app.comp.grow-demo $ :require
          [] phlox.core :refer $ [] defcomp g hslx rect circle text container graphics create-list hslx
          [] app.util :refer $ [] add-path multiply-path
          [] app.comp.reset :refer $ [] comp-reset
          [] clojure.core.rrb-vector :refer $ [] catvec
          [] "\"shortid" :as shortid
          [] app.util :refer $ [] rand-point
          "\"@calcit/std" :refer $ rand rand-int
      :defs $ {}
        |generate-trails $ quote
          defn generate-trails ()
            reset! *grid $ {}
            let
                trails $ -> (range 12)
                  map $ fn (x) (rand-point 140 60)
                  .distinct
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
        |pick-many $ quote
          defn pick-many (xs)
            if
              = 3 $ count xs
              case-default (rand-int 3) xs
                0 $ .slice xs 1
                1 $ [] (nth xs 0) (nth xs 2)
                2 $ .slice xs 0 2
              , xs
        |get-trail-ops $ quote
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
        |*grid $ quote
          defatom *grid $ {}
        |expand-directions $ quote
          defn expand-directions (base)
            []
              add-path base $ [] 0 -1
              add-path base $ [] 0 1
              add-path base $ [] 1 0
              add-path base $ [] -1 0
        |comp-grow-demo $ quote
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
        |iterate-trails $ quote
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
                  concat $ mapcat result first
                  filter-not $ fn (pair)
                    let-sugar
                          [] k point
                          , pair
                        directions $ expand-directions point
                        available $ -> directions
                          filter-not $ fn (x) (get @*grid x)
                      empty? available
                mapcat result last
    |app.comp.snowflake-demo $ {}
      :ns $ quote
        ns app.comp.snowflake-demo $ :require
          [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
          [] app.comp.reset :refer $ [] comp-reset
          [] app.util :refer $ [] rand-point add-path subtract-path divide-x multiply-path divide-path invert-y
          [] phlox.comp.drag-point :refer $ [] comp-drag-point
          [] phlox.comp.button :refer $ [] comp-button
          [] phlox.comp.slider :refer $ [] comp-slider
          [] phlox.comp.switch :refer $ [] comp-switch
      :defs $ {}
        |odd? $ quote
          defn odd? (n)
            not= 0 $ .rem n 2
        |fold-curve $ quote
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
        |comp-snowflake-demo $ quote
          defcomp comp-snowflake-demo (states)
            let
                cursor $ :cursor states
                state $ or (:data states)
                  {} (:steps 1)
                    :points $ [] ([] 0 300) ([] 140 300)
                    :shaking? false
              container ({})
                container
                  {} $ :position ([] -100 -60)
                  comp-button $ {} (:text "\"Add")
                    :position $ [] -60 0
                    :on $ {}
                      :pointertap $ fn (e d!)
                        d! cursor $ update state :points
                          fn (points)
                            conj (butlast points)
                              add-path (last points) ([] -80 -60)
                              last points
                  comp-button $ {} (:text "\"Reduce")
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
                      :value $ :steps state
                      :position $ [] 80 0
                      :unit 0.1
                      :title "\"Steps"
                      :min 0
                      :max $ if
                        >= 3 $ count (:points state)
                        , 12 6
                      :round? true
                      :on-change $ fn (value d!)
                        d! cursor $ assoc state :steps value
                  comp-switch $ {}
                    :value $ :shaking? state
                    :position $ [] 200 0
                    :title "\"Shake"
                    :on-change $ fn (v d!)
                      d! cursor $ assoc state :shaking? v
                graphics $ {}
                  :position $ [] 0 0
                  :ops $ let
                      trail $ fold-curve (:points state) (:steps state) (:shaking? state)
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
                  -> (:points state)
                    map-indexed $ fn (idx point)
                      [] idx $ comp-drag-point (>> states idx)
                        {} (:position point)
                          :title $ str "\"p" idx
                          :alpha 0.5
                          :color $ hslx 300 80 50
                          :on-change $ fn (position d!)
                            d! cursor $ assoc-in state ([] :points idx) position
    |app.comp.rotate-demo $ {}
      :ns $ quote
        ns app.comp.rotate-demo $ :require
          [] phlox.core :refer $ [] defcomp >> hslx g rect circle text container graphics create-list hslx
          [] app.comp.reset :refer $ [] comp-reset
          [] app.util :refer $ [] rand-point
          [] phlox.comp.drag-point :refer $ [] comp-drag-point
          [] phlox.comp.slider :refer $ [] comp-slider
          "\"@calcit/std" :refer $ rand rand-int
      :defs $ {}
        |gen-trail $ quote
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
        |comp-rotate-demo $ quote
          defcomp comp-rotate-demo (states)
            let
                cursor $ :cursor states
                state $ or (:data states)
                  {}
                    :points $ -> (range 12)
                      map $ fn (idx)
                        []
                          + 200 $ rand 100
                          rand 100
                    :steps 18
                    :base 20
                    :alpha 1
                points $ :points state
              container
                {} $ :position ([] 240 400)
                create-list :container ({})
                  ->
                    range $ :steps state
                    map $ fn (idx)
                      [] idx $ graphics
                        {}
                          :ops $ gen-trail points (:alpha state)
                          :angle $ * idx (:base state)
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
                              :else 240
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
        |get-round? $ quote
          defn get-round? (param)
            case param (:steps true) (do false)
    |app.config $ {}
      :ns $ quote
        ns app.config $ :require ("\"mobile-detect" :default mobile-detect)
      :defs $ {}
        |cdn? $ quote
          def cdn? $ cond
              exists? js/window
              , false
            (exists? js/process) (= "\"true" js/process.env.cdn)
            :else false
        |dev? $ quote
          def dev? $ let
              debug? $ do ^boolean js/goog.DEBUG
            cond
                exists? js/window
                , debug?
              (exists? js/process) (not= "\"true" js/process.env.release)
              :else true
        |site $ quote
          def site $ {} (:dev-ui "\"http://localhost:8100/main-fonts.css") (:release-ui "\"http://cdn.tiye.me/favored-fonts/main-fonts.css") (:cdn-url "\"http://cdn.tiye.me/circling-tree/") (:title "\"Circling Tree") (:icon "\"http://cdn.tiye.me/logo/quamolit.png") (:storage-key "\"circling-tree")
        |mobile? $ quote
          def mobile? $ .!mobile (new mobile-detect js/window.navigator.userAgent)
