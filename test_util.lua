-- test_util.lua
-- Tests for the utility functions.
-- Copyright © 2015, Matthias Hölzl
-- Licensed under the MIT license, see the file LICENSE.md.

util = require("util")
lunatest = require("lunatest")

local assert_equal = lunatest.assert_equal
local assert_not_equal = lunatest.assert_not_equal
local assert_error = lunatest.assert_error
local assert_false = lunatest.assert_false
local assert_not_false = lunatest.assert_not_false
local assert_table = lunatest.assert_table
local assert_not_table = lunatest.assert_not_table
local assert_true = lunatest.assert_true
local assert_nil = lunatest.assert_nil
local fail = lunatest.fail
local jit = jit

local t = {}

function t.test_uuid ()
  -- Only test for the correct pattern.
  assert_true(string.match(
      util.uuid(),
      "%x%x%x%x%x%x%x%x%-%x%x%x%x%-4%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x"))
  -- Check that freshly generated uuids are distinct
  assert_not_equal(util.uuid(), util.uuid())
end

function t.test_size ()
  assert_equal(util.size({}), 0)
  assert_equal(util.size({1, 2, 3}), 3)
  assert_equal(util.size({1, {2}, {1, 2, 3}, 4}), 4)
  assert_equal(util.size({x = 1, y = "Y"}), 2)
end

function t.test_equal_1 ()
  assert_true(util.equal(1, 1))
  assert_false(util.equal(1, 2))
  assert_true(util.equal("foo", "foo"))
  assert_false(util.equal("foo", "bar"))
end

function t.test_equal_2 ()
  assert_true(util.equal({}, {}))
  assert_false(util.equal({}, {1}))
  assert_false(util.equal({1}, {}))
  assert_false(util.equal({}, {x = "X"}))
  assert_false(util.equal({x = "X"}, {}))
end

function t.test_equal_3 ()
  assert_true(util.equal({1, 2, 3}, {1, 2, 3}))
  assert_false(util.equal({1, 2, 3}, {1, 2, 3, 4}))
  assert_false(util.equal({1, 2}, {1, 2, 3}))
  assert_false(util.equal({1, 2, 3, 4}, {1, 2}))
end

function t.test_equal_4 ()
  assert_false(util.equal({1, 2, 3}, {1, 3, 2}))
  assert_false(util.equal({3, 1, 2}, {1, 2, 3}))
  assert_false(util.equal({1, 2, 3}, {3, 2, 1}))
end

function t.test_equal_5 ()
  assert_true(util.equal({x="X", y="Y", z="Z"}, {x="X", y="Y", z="Z"}))
  assert_false(util.equal({x="X", y="Y", z="Z"}, {x="X", y="Y", z="Z", w="W"}))
  assert_false(util.equal({x="X", y="Y", z="Z"}, {x="X", y="Y"}))
  assert_false(util.equal({x="X", y="Y", z="Z", w="W"}, {x="X", y="Y", z="Z"}))
  assert_false(util.equal({x="X", y="Y"}, {x="X", y="Y", z="Z"}))
end

function t.test_addall_1 ()
  local t1 = {}
  local res = util.addall(t1, {x = "XX", y = "YY"})
  assert_table(res)
  assert_true(util.equal(res, {x = "XX", y = "YY"}))
  assert_true(util.equal(t1, {x = "XX", y = "YY"}))
end

function t.test_addall_2 ()
  local t1 = {a = "AA", b = "BB", x = "XX"}
  local res = util.addall(t1, {x = "xx", y = "YY"})
  assert_table(res)
  assert_true(util.equal(res, {a = "AA", b = "BB", x = "xx", y = "YY"}))
  assert_true(util.equal(t1, {a = "AA", b = "BB", x = "xx", y = "YY"}))
end

function t.test_keys ()
  assert_true(util.equal(util.keys({}), {}))
  assert_true(util.equal(util.keys({10, 20, 30}), {1, 2, 3}))
  assert_true(util.equal(util.keys({x="X", y="Y"}), {"x", "y"}))
end

function t.test_append ()
  assert_true(util.equal(util.append({1,2,3}, {}), {1,2,3}))
  assert_true(util.equal(util.append({}, {1,2,3}), {1,2,3}))
  assert_true(util.equal(util.append({1,2,3}, {4,5,6}), {1,2,3,4,5,6}))
end

return t