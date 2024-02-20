(module plugins
  {autoload {
    nvim aniseed.nvim
    core aniseed.core
	fs   aniseed.fs}})

((. (require :lazy) :setup) 
 (core.map (fn [path]
             (require (string.gsub path "^/(.*)[.]fnl$" "plugins.%1")))
           (fs.relglob (.. (vim.fn.stdpath "config")
                           "/fnl/plugins")
                       "*.fnl")))
