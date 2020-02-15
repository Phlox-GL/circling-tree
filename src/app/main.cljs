
(ns app.main
  (:require ["pixi.js" :as PIXI]
            [phlox.core :refer [render!]]
            [app.container :refer [comp-container]]
            [app.schema :as schema]
            ["shortid" :as shortid]))

(defonce *store (atom schema/store))

(defn updater [store op op-data op-id]
  (case op
    :tab (assoc store :tab op-data)
    :touch (assoc store :touch-key op-id)
    (do (println "unknown op" op op-data) store)))

(defn dispatch! [op op-data]
  (println "dispatch!" op op-data)
  (let [op-id (shortid/generate)] (reset! *store (updater @*store op op-data op-id))))

(defn main! []
  (comment js/console.log PIXI)
  (render! (comp-container @*store) dispatch! {})
  (add-watch *store :change (fn [] (render! (comp-container @*store) dispatch! {})))
  (println "App Started"))

(defn reload! []
  (println "Code updated")
  (render! (comp-container @*store) dispatch! {:swap? true}))
