
(ns app.updater (:require [phlox.cursor :refer [update-states]]))

(defn updater [store op op-data op-id op-time]
  (case op
    :tab (assoc store :tab op-data)
    :touch (assoc store :touch-key op-id)
    :states (update-states store op-data)
    (do (println "unknown op" op op-data) store)))
