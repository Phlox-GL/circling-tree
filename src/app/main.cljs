
(ns app.main
  (:require ["pixi.js" :as PIXI]
            [phlox.core :refer [render!]]
            [app.comp.container :refer [comp-container]]
            [app.schema :as schema]
            ["shortid" :as shortid]
            [app.updater :refer [updater]]
            ["fontfaceobserver" :as FontFaceObserver]
            [phlox.core :as phlox-core]))

(defonce *store (atom schema/store))

(defn dispatch! [op op-data]
  (when (not= op :states) (println "dispatch!" op op-data))
  (let [op-id (shortid/generate), op-time (.now js/Date)]
    (reset! *store (updater @*store op op-data op-id op-time))))

(defn main! []
  (comment js/console.log PIXI)
  (render! (comp-container @*store) dispatch! {})
  (-> (FontFaceObserver. "Josefin Sans")
      (.load)
      (.then (fn [] (render! (comp-container @*store) dispatch! {}))))
  (add-watch *store :change (fn [] (render! (comp-container @*store) dispatch! {})))
  (set!
   (-> @phlox-core/*app .-renderer .-plugins .-interaction .-interactionFrequency)
   1000)
  (-> @phlox-core/*app .-renderer .-plugins .-interaction .update)
  (println
   "code"
   (-> @phlox-core/*app .-renderer .-plugins .-interaction .-interactionFrequency))
  (println "App Started"))

(defn reload! []
  (println "Code updated")
  (render! (comp-container @*store) dispatch! {:swap? true}))
