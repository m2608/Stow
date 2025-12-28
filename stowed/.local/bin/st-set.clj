#!/usr/bin/env bb

(require '[clojure.string :as str]
         '[babashka.fs :as fs]
         '[babashka.process :refer [shell]])

(def themes-base (str (System/getenv "HOME") "/Themes/output/base16-st-resources/Xresources"))
(def themes-pref "")

(def help
  (let [script (System/getProperty "babashka.file")]
    (str "Usage: " (last (str/split script #"/")) " <option> <value>

Options:

font  - set font
size  - set font size
theme - set color theme
")))

(when (empty? *command-line-args*)
  (println help)
  (System/exit 0))

(defn get-resource
  "Parses resource from resource database."
  [name]
  (let [resources (:out (shell {:out :string} "xrdb" "-query"))
        res-line (->> resources
                      str/split-lines
                      (filter (fn [line]
                                (str/starts-with? line (str name ":"))))
                      first)]
    (->> (str/split res-line #":" 2)
         second
         str/trim)))

(defn parse-font
  [font-string]
  (let [[font & opts] (str/split font-string #":")]
    [font (into {} (map (fn [opt]
                          (let [[k v] (str/split opt #"=" 2)]
                            [(keyword k) v]))
                        opts))]))

(defn get-font
  []
  (parse-font (get-resource "st.font")))

(defn set-resource
  [name value]
  "Sets resource in resource database."
  (let [temp-path (fs/create-temp-file)
        temp-name (str temp-path)]
    (spit temp-name (format "%s:\t%s\n" name value))
    (shell "xrdb" "-merge" temp-name)
    (fs/delete temp-path)))

(defn set-font
  "Sets st font merging all the opts."
  [[new-font new-opts]]
  (let [[_ old-opts] (get-font)]
    (->> (merge old-opts new-opts)
         (map (fn [[k v]]
                (format "%s=%s" (name k) v)))
         (cons new-font)
         (str/join ":")
         (set-resource "st.font"))))

(defn set-theme
  "Sets st color theme (just merges file specified to X resources db)."
  [filename]
  (shell "xrdb" "-merge" filename))

(defn update-st
  "Reloads `st` config from resource database."
  []
  (apply shell
         (if (re-find #"FreeBSD" (:out (shell "uname -a" {:out :string})))
           ["pkill" "-USR1" "-a" "-x" "st"]
           ["pkill" "-USR1"      "-x" "st"])))
  
(let [[option value] *command-line-args*]
  (when (nil? value)
    (println help)
    (System/exit 1))

  (case option
    "font"
    (set-font (parse-font value))
    
    "size"
    (let [[font opts] (get-font)]
      (cond
        (re-matches #"^[+-]\d+$" value)
        (let [new-size (+ (Integer/parseInt (:size opts))
                          (Integer/parseInt value))]
          (set-font [font (update opts :size (fn [size] (if (pos? new-size) new-size size)))]))
        
        (re-matches #"^\d+$" value)
        (set-font [font (assoc opts :size (str (Integer/parseInt value)))])
        
        :else
        (do (println "Wrong font size format:" value)
            (System/exit 1))))
    
    "theme"
    (let [theme-probe (str themes-base "/" themes-pref value)]
      (cond
        ;; Check for literal file.
        (fs/exists? value)
        (set-theme value)

        ;; Check for theme in `themes-base` dir.
        (fs/exists? theme-probe)
        (set-theme theme-probe)

        :else
        (do (println "Could not find the theme specified:" value)
            (System/exit 1))))
    
    (do (println "Unknown option:" option)
        (System/exit 1))))

(update-st)
