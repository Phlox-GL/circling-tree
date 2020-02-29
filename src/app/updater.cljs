
(ns app.updater )

(defn updater [store op op-data op-id op-time]
  (case op
    :tab (assoc store :tab op-data)
    :touch (assoc store :touch-key op-id)
    :states
      (let [[cursor new-state] op-data, path (conj cursor :data)]
        (assoc-in store (concat [:states] path) new-state))
    (do (println "unknown op" op op-data) store)))
