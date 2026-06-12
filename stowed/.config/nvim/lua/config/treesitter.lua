-- [nfnl] fnl/config/treesitter.fnl
local _local_1_ = require("nfnl.core")
local assoc = _local_1_.assoc
local merge = _local_1_.merge
local first = _local_1_.first
local second = _local_1_.second
local map = _local_1_.map
local filter = _local_1_.filter
local kv_pairs = _local_1_["kv-pairs"]
local empty_3f = _local_1_["empty?"]
local reduce = _local_1_.reduce
local keys = _local_1_.keys
local str = require("nfnl.string")
local parsers = {clojure = {repo = "sogaiu/tree-sitter-clojure"}, cpp = {repo = "tree-sitter/tree-sitter-cpp"}, fennel = {repo = "alexmozaidze/tree-sitter-fennel"}, html = {repo = "tree-sitter/tree-sitter-html"}, hurl = {repo = "pfeiferj/tree-sitter-hurl"}, janet_simple = {repo = "sogaiu/tree-sitter-janet-simple"}, jq = {repo = "flurie/tree-sitter-jq"}, json = {repo = "tree-sitter/tree-sitter-json"}, make = {repo = "tree-sitter-grammars/tree-sitter-make"}, python = {repo = "tree-sitter/tree-sitter-python"}, scheme = {repo = "6cdh/tree-sitter-scheme"}, yaml = {repo = "tree-sitter-grammars/tree-sitter-yaml"}}
local tsitter_path = vim.fs.joinpath(os.getenv("HOME"), ".local/share/nvim/treesitter")
local parsers_path = vim.fs.joinpath(tsitter_path, "parser")
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
  print(vim.inspect(fails))
  if empty_3f(fails) then
    return ok(rs)
  else
    return err("Requirements not satisfied: ", str.join(", ", fails), ".")
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
  local _, e = vim.fs.rm(path, {recursive = true})
  if not e then
    return ok(path)
  else
    return err("Could not remove folder: ", path)
  end
end
local function clone_repo(repo, path)
  local r = run({"git", "clone", "--depth=1", ("https://github.com/" .. repo), path})
  if (0 == r.code) then
    return ok(path)
  else
    return err("Could not clone repository: ", repo)
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
  local function _11_(s)
    return str["ends-with?"](s, ".so")
  end
  lib = first(vim.fn.readdir(path, _11_))
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
local function add_parser(parsers_path0, parser, repo, force_rebuild)
  local dst = vim.fs.joinpath(parsers_path0, (parser .. ".so"))
  if (not force_rebuild and vim.uv.fs_stat(dst)) then
    return ok(dst)
  else
    local temp_dir = create_temp_dir()
    if temp_dir then
      print(("Cloning repo " .. repo .. "..."))
      local function _14_(_)
        return build_parser(temp_dir)
      end
      local function _15_(_)
        return find_parser_lib(temp_dir)
      end
      local function _16_(lib)
        return copy_parser_lib(lib, dst)
      end
      local function _17_(_)
        return remove_dir(temp_dir)
      end
      return bind(log(bind(bind(bind(log(clone_repo(repo, temp_dir), "Building parser ", parser, "..."), _14_), _15_), _16_), "Parser copied to ", dst), _17_)
    else
      return err("Could not create temporary folder.")
    end
  end
end
local function build_all(parsers_path0, parsers0, force_rebuild)
  local statuses
  local function _21_(acc, _20_)
    local parser = _20_[1]
    local repo = _20_[2]
    local result = add_parser(parsers_path0, parser, parsers0[parser].repo, force_rebuild)
    return assoc(acc, parser, (result.status == "ok"))
  end
  statuses = reduce(_21_, {}, kv_pairs(parsers0))
  local fails
  local function _23_(_22_)
    local _ = _22_[1]
    local status = _22_[2]
    return not status
  end
  fails = map(first, filter(_23_, kv_pairs(statuses)))
  if empty_3f(fails) then
    return ok(keys(parsers0))
  else
    return err("Some parsers weren't built: ", str.join(", ", fails), ".")
  end
end
local function setup(force_build)
  local result
  local function _25_(_)
    if force_build then
      return remove_dir(parsers_path)
    else
      return ok(parsers_path)
    end
  end
  local function _27_(_)
    return create_dir(parsers_path)
  end
  local function _28_(_)
    vim.opt.runtimepath:append(tsitter_path)
    return ok(tsitter_path)
  end
  local function _29_(_)
    return build_all(parsers_path, parsers, false)
  end
  result = bind(bind(bind(bind(check_requirements({"clang", "tree-sitter"}), _25_), _27_), _28_), _29_)
  if (result.status == "ok") then
    return vim.notify("All the parsers were build successfully", vim.log.levels.INFO)
  else
    return vim.notify(result.msg, vim.log.levels.ERROR)
  end
end
setup()
local function _31_()
  return vim.treesitter.start()
end
return vim.api.nvim_create_autocmd({"FileType"}, {pattern = {"fenne"}, callback = _31_})
