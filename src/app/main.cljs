
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
    :states
      (let [[cursor new-state] op-data, path (conj cursor :data)]
        (assoc-in store (concat [:states] path) new-state))
    (do (println "unknown op" op op-data) store)))

(defn dispatch! [op op-data]
  (println "dispatch!" op op-data)
  (case op
    :states
      (when-not (and (vector? op-data) (= 2 (count op-data)) (vector? (first op-data)))
        (js/console.error "Invalid states op:" op-data))
    (do))
  (let [op-id (shortid/generate)] (reset! *store (updater @*store op op-data op-id))))

(defn main! []
  (comment js/console.log PIXI)
  (render! (comp-container @*store) dispatch! {})
  (add-watch *store :change (fn [] (render! (comp-container @*store) dispatch! {})))
  (println "App Started"))

(defn reload! []
  (println "Code updated")
  (render! (comp-container @*store) dispatch! {:swap? true}))
