#!/usr/bin/env bb

;; Скрипт убирает изображения обложки из fb2, переданного на stdin. Другие картинки
;; не трогает.

;; Причина: старые электронные книги с трудом открывают fb2 с изображениями большого
;; размера.

;; В fb2 формате сами изображения хранятся в теге <binary>, понять же, какие из них
;; представляют собой обложку, можно, прочитав идентификаторы из дочерних элементов
;; тега <coverpage>.
;;
;; В теге <coverpage> содержится тег <image>, в поле href которого лежит ссылка на
;; изображения. Внутренние ссылки делаются через anchor, например:
;;
;; <coverpage>
;;   <image href="#image.jpg" />
;; </coverpage>
;;
;; Изображение будет содержать ту же самую строку в качестве идентификатора (но уже
;; без anchor'а).
;;
;; <binary id="image.jpg">
;;   ...
;; </binary>

(require '[clojure.string :as str]
         '[clojure.data.xml :as xml]
         '[clojure.walk :as walk])

(defn get-tag
  "Получает содержимое xml-тега по пути к нему. На пути каждый раз выбирает
  первый тег, возвращает список."
  [xml-data & keys]
  (when-let [xml-tag (->> xml-data :content (filter #(= (:tag %) (first keys))))]
    (if (empty? (rest keys))
      xml-tag
      (recur (first xml-tag) (rest keys)))))

(defn get-cover-images
  "Возвращает список идентификаторов изображений, используемых в качестве обложки
  для данной книги."
  [xml-data]
  (let [images-ids (map #(get-in % [:attrs :href])
                        (get-tag xml-data :description :title-info :coverpage :image))]
    (for [image-id images-ids
          :when (str/starts-with? image-id "#")]
      (subs image-id 1))))

(let [xml-data (xml/parse *in* :namespace-aware false)
      remove-image? (set (get-cover-images xml-data))]
  (-> (walk/postwalk
        (fn [node]
          (if (and (map? node)
                   ;; Убираем <coverpage>, а также - <binary>, в которых содержатся
                   ;; изображения с обложки.
                   (or (= (:tag node) :coverpage)
                       (and (= (:tag node) :binary)
                            (remove-image? (get-in node [:attrs :id])))))
            nil
            node))
        xml-data)
      xml/emit-str
      print))
