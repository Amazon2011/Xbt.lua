--- Example file for the XBT module.
-- This file contains some functions that are used in the
-- quickstart tutorial.
-- 
-- @copyright © 2015, Matthias Hölzl
-- @author Matthias Hölzl
-- @license MIT, see the file LICENSE.md.
-- @module run_example
-- 
local xbt = require("xbt")
local util = require("xbt.util")
local xbt_path = require("xbt.path")
local graph = require("xbt.graph")
local nodes = require("example.nodes")
local tablex = require("pl.tablex")
local math = require("sci.math")
local prng = require("sci.prng")

local ex = {}


function ex.graph_copy ()
  local g = graph.generate_graph(10, 10, graph.make_short_edge_generator(1.5))
  local gc = graph.copy(g)
  local gcb1 = graph.copy_badly(g, 1)
  local gcb2 = graph.copy_badly(g)
  for i=1,#g.edges do
    print("Edge " .. i .. ": \t"
      .. g.edges[i].reward .. ", \t" .. gc.edges[i].reward .. ", \t"
      .. gcb1.edges[i].reward .. ", \t" .. gcb2.edges[i].reward)
  end
end

function ex.graph_update_edge_reward ()
  local g = graph.generate_graph(10, 10, graph.generate_all_edges)
  local gc = graph.copy_badly(g, 50)
  local sample = {from=1, to=2, reward=g.nodes[1].edges[2].reward}
  for i=1,20 do
    print("N = " .. i .. "\t"
      .. g.edges[1].reward .. ", \t" .. gc.edges[1].reward)
    graph.update_edge_reward(gc, sample)
  end
end

function ex.graph_update_edge_rewards ()
  local g = graph.generate_graph(10, 10, graph.generate_all_edges)
  local gc = graph.copy_badly(g, 50)
  local samples = {
    {from=1, to=2, reward=g.nodes[1].edges[2].reward},
    {from=1, to=3, reward=g.nodes[1].edges[3].reward}}
  for i=1,20 do
    print("N = " .. i .. "\t"
      .. g.nodes[1].edges[2].reward .. ", \t"
      .. gc.nodes[1].edges[2].reward .. ", \t"
      .. g.nodes[1].edges[3].reward .. ", \t"
      .. gc.nodes[1].edges[3].reward)
    graph.update_edge_rewards(gc, samples)
  end
end


function ex.navigate_graph ()
  print("Navigating graph...")
  local g = graph.generate_graph(100, 500, graph.make_short_edge_generator(1.2))
  print("Diameter:        ", graph.diameter(g.nodes))
  local d,n = graph.maxmin_distance(g.nodes)
  print("Maxmin distance: ", d, "for node", n)
  print("Nodes:           ", #g.nodes, "Edges:", #g.edges)
  for i=1,5 do
    for j = i,5 do
      print(i, "->", j, graph.pathstring(g, i, j))
    end
  end
  local a,t = graph.make_graph_action_tables(g)
  print("Action table sizes: ", #a, #t)
end

function ex.search ()
  print("Searching...")  
  local searcher = nodes.searcher
  local path = xbt_path.new()
  local state = xbt.make_state()
  local res = xbt.tick(searcher, path, state)
  print("result:\t", res.status .. "   ", res.reward)
  while not xbt.is_done(res) do
    res = xbt.tick(searcher, path, state)
    print("result:\t", res.status .. "   ", res.reward)
  end
  -- Show that finished results stay constant
  for _=1,2 do
    res = xbt.tick(searcher, path, state)
    print("result:\t", res.status .. "   ", res.reward)
  end
end

function ex.tick_suppress_failure ()
  print("Ticking suppressing failures...")
  local node = xbt.suppress_failure(nodes.searcher)
  local path = xbt_path.new()
  local state = xbt.make_state()
  local res = xbt.tick(node, path, state)
  print("result:\t", res.status .. "   ", res.reward)
  while not xbt.is_done(res) do
    res = xbt.tick(node, path, state)
    print("result:\t", res.status .. "   ", res.reward)
  end
end

function ex.tick_negate ()
  print("Ticking negated node...")
  local node = xbt.negate(nodes.searcher)
  local path = xbt_path.new()
  local state = xbt.make_state()
  local res = xbt.tick(node, path, state)
  print("result:\t", res.status .. "   ", res.reward)
  while not xbt.is_done(res) do
    res = xbt.tick(node, path, state)
    print("result:\t", res.status .. "   ", res.reward)
  end
end


--[[--
ex.graph_copy()
ex.graph_update_edge_reward()
ex.graph_update_edge_rewards()
ex.navigate_graph()
ex.search()
ex.tick_suppress_failure()
ex.tick_negate()
--]]--

return ex
