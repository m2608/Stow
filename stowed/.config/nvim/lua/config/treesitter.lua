-- [nfnl] fnl/config/treesitter.fnl
local _local_1_ = require("nfnl.core")
local assoc = _local_1_.assoc
local merge = _local_1_.merge
local first = _local_1_.first
local second = _local_1_.second
local map = _local_1_.map
local filter = _local_1_.filter
local reduce = _local_1_.reduce
local concat = _local_1_.concat
local keys = _local_1_.keys
local kv_pairs = _local_1_["kv-pairs"]
local empty_3f = _local_1_["empty?"]
local nil_3f = _local_1_["nil?"]
local str = require("nfnl.string")
local parsers = {clojure = {repo = "sogaiu/tree-sitter-clojure"}, cpp = {repo = "tree-sitter/tree-sitter-cpp"}, fennel = {repo = "alexmozaidze/tree-sitter-fennel"}, html = {repo = "tree-sitter/tree-sitter-html"}, hurl = {repo = "pfeiferj/tree-sitter-hurl"}, janet_simple = {repo = "sogaiu/tree-sitter-janet-simple"}, jq = {repo = "flurie/tree-sitter-jq"}, json = {repo = "tree-sitter/tree-sitter-json"}, make = {repo = "tree-sitter-grammars/tree-sitter-make"}, markdown = {repo = "tree-sitter-grammars/tree-sitter-markdown", ["rel-path"] = "tree-sitter-markdown"}, markdown_inline = {repo = "tree-sitter-grammars/tree-sitter-markdown", ["rel-path"] = "tree-sitter-markdown-inline"}, python = {repo = "tree-sitter/tree-sitter-python", checkout = "v0.25.0"}, scheme = {repo = "6cdh/tree-sitter-scheme"}, yaml = {repo = "tree-sitter-grammars/tree-sitter-yaml"}}
local queries = {repo = "nvim-treesitter/nvim-treesitter", branch = "main", subfolder = "runtime/queries"}
local tsitter_path = vim.fs.joinpath(os.getenv("HOME"), ".local/share/nvim/treesitter")
local function ok(val)
  return {status = "ok", val = val}
end
local function err(...)
  return {status = "err", msg = str.join({...})}
end
local function bind(result, f)
  if (result.status == "ok") then
    return f(result.val)
  else
    return result
  end
end
local function log(result, ...)
  if (result.status == "ok") then
    print(str.join({...}))
  else
  end
  return result
end
local function run(cmd, opts)
  local p = vim.system(cmd, merge({text = true}, opts))
  return p:wait()
end
local function check_requirements(rs)
  local fails
  local function _4_(r)
    return (0 == vim.fn.executable(r))
  end
  fails = filter(_4_, rs)
  if empty_3f(fails) then
    return ok(rs)
  else
    return err("TreeSitter requirements not satisfied: ", str.join(", ", fails), ".")
  end
end
local function create_dir(path)
  local r = run({"mkdir", "-p", path})
  if (0 == r.code) then
    return ok(path)
  else
    return err("Could not create folder: ", path)
  end
end
local function create_temp_dir(path)
  local r = run({"mktemp", "-d"})
  if (0 == r.code) then
    return first(str.split(r.stdout, "\n"))
  else
    return nil
  end
end
local function remove_dir(path)
  if vim.uv.fs_stat(path) then
    local _, e = vim.fs.rm(path, {recursive = true})
    if not e then
      return ok(path)
    else
      return err("Could not remove folder: ", path)
    end
  else
    return ok(path)
  end
end
local function copy_dir(src, dst)
  print("Copying", src, "to", dst)
  local r = run({"cp", "-r", src, dst})
  if (0 == r.code) then
    return ok(dst)
  else
    return err("Could not copy folder ", src, " to ", dst)
  end
end
local function clone_repo(repo, branch, path)
  local r
  local _11_
  if nil_3f(branch) then
    _11_ = {}
  else
    _11_ = {("--branch=" .. branch)}
  end
  r = run(concat({"git", "clone", "--depth=1"}, _11_, {("https://github.com/" .. repo), path}))
  if (0 == r.code) then
    return ok(path)
  else
    return err("Could not clone repository: ", repo)
  end
end
local function checkout(checkout0, path)
  if nil_3f(checkout0) then
    local r = run({"git", "checkout", checkout0}, {cwd = path})
    if (0 == r.code) then
      return ok(path)
    else
      return err("Couldn't checkout to ", checkout0)
    end
  else
    return ok(path)
  end
end
local function build_parser(path)
  local r = run({"tree-sitter", "build"}, {cwd = path})
  if (0 == r.code) then
    return ok(path)
  else
    return err("Could not build parser at ", path)
  end
end
local function find_parser_lib(path)
  local lib
  local function _17_(s)
    return str["ends-with?"](s, ".so")
  end
  lib = first(vim.fn.readdir(path, _17_))
  if lib then
    return ok(vim.fs.joinpath(path, lib))
  else
    return err("Could not find parser library at ", path)
  end
end
local function copy_parser_lib(lib_path, dst)
  local _, e = vim.uv.fs_copyfile(lib_path, dst)
  if not e then
    return ok(dst)
  else
    return err("Could not copy ", lib_path, " into ", dst, ".")
  end
end
local function add_parser(parsers_path, parser_name, parser_data, force_rebuild)
  local dst = vim.fs.joinpath(parsers_path, (parser_name .. ".so"))
  if (not force_rebuild and vim.uv.fs_stat(dst)) then
    return ok(dst)
  else
    local temp_dir = create_temp_dir()
    if temp_dir then
      local repo = parser_data.repo
      local relp = parser_data["rel-path"]
      local build_dir
      if relp then
        build_dir = vim.fs.joinpath(temp_dir, relp)
      else
        build_dir = temp_dir
      end
      local result
      local function _21_(_)
        return clone_repo(repo, parser_data.branch, temp_dir)
      end
      local function _22_(_)
        return checkout(parser_data.checkout, temp_dir)
      end
      local function _23_(_)
        return build_parser(build_dir)
      end
      local function _24_(_)
        return find_parser_lib(build_dir)
      end
      local function _25_(lib)
        return copy_parser_lib(lib, dst)
      end
      result = log(bind(bind(bind(log(bind(bind(log({status = "ok"}, "Cloning repo ", repo, "..."), _21_), _22_), "Building parser ", parser_name, "..."), _23_), _24_), _25_), "Parser copied to ", dst)
      remove_dir(temp_dir)
      return result
    else
      return err("Could not create temporary folder.")
    end
  end
end
local function add_queries(tsitter_path0, queries0, force_rebuild)
  local queries_path = vim.fs.joinpath(tsitter_path0, "queries")
  if (not force_rebuild and vim.uv.fs_stat(queries_path)) then
    return ok(queries_path)
  else
    local temp_dir = create_temp_dir()
    local repo = queries0.repo
    if temp_dir then
      local result
      local function _28_(_)
        return clone_repo(repo, queries0.branch, temp_dir)
      end
      local function _29_(_)
        return remove_dir(queries_path)
      end
      local function _30_(_)
        return copy_dir(vim.fs.joinpath(temp_dir, queries0.subfolder), tsitter_path0)
      end
      result = log(bind(bind(bind(log({status = "ok"}, "Cloning repo ", repo, "..."), _28_), _29_), _30_), "Queries copied to ", queries_path)
      remove_dir(temp_dir)
      return result
    else
      return err("Could not create temporary folder.")
    end
  end
end
local function build_all(parsers_path, parsers0, force_rebuild)
  local statuses
  local function _34_(acc, _33_)
    local parser_name = _33_[1]
    local parser_data = _33_[2]
    local result = add_parser(parsers_path, parser_name, parser_data, force_rebuild)
    return assoc(acc, parser_name, (result.status == "ok"))
  end
  statuses = reduce(_34_, {}, kv_pairs(parsers0))
  local fails
  local function _36_(_35_)
    local _ = _35_[1]
    local status = _35_[2]
    return not status
  end
  fails = map(first, filter(_36_, kv_pairs(statuses)))
  if empty_3f(fails) then
    return ok(keys(parsers0))
  else
    return err("Some parsers weren't built: ", str.join(", ", fails), ".")
  end
end
local function setup(tsitter_path0, parsers0, queries0, force_rebuild)
  local parsers_path = vim.fs.joinpath(tsitter_path0, "parser")
  local queries_path = vim.fs.joinpath(tsitter_path0, "queries")
  local result
  local function _38_(_)
    if force_rebuild then
      local function _39_(_0)
        return remove_dir(queries_path)
      end
      return bind(remove_dir(parsers_path), _39_)
    else
      return ok()
    end
  end
  local function _41_(_)
    return create_dir(parsers_path)
  end
  local function _42_(_)
    vim.opt.runtimepath:append(tsitter_path0)
    return ok(tsitter_path0)
  end
  local function _43_(_)
    return build_all(parsers_path, parsers0, force_rebuild)
  end
  local function _44_(_)
    return add_queries(tsitter_path0, queries0, force_rebuild)
  end
  result = bind(bind(bind(bind(bind(check_requirements({"clang", "tree-sitter"}), _38_), _41_), _42_), _43_), _44_)
  if (result.status ~= "ok") then
    return vim.notify(result.msg, vim.log.levels.INFO)
  else
    return nil
  end
end
setup(tsitter_path, parsers, queries)
local function _46_()
  return vim.treesitter.start()
end
return vim.api.nvim_create_autocmd({"FileType"}, {pattern = {"fennel", "python"}, callback = _46_})
