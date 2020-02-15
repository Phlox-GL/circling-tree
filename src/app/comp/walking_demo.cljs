
(ns app.comp.walking-demo
  (:require [phlox.core
             :refer
             [defcomp hslx rect circle text container graphics create-list hslx]]))

(defcomp
 comp-walking-demo
 ()
 (text {:text "TODO", :position [200 200], :style {:fill (hslx 0 0 100), :font-size 14}}))
