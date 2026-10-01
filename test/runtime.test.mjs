import assert from 'node:assert/strict';
import test from 'node:test';
import { registerHooks } from 'node:module';
import * as c from '../js-out/calcit.core.mjs';
import { store } from '../js-out/app.schema.mjs';
import { updater } from '../js-out/app.updater.mjs';
const previous = Object.fromEntries(['window', 'document'].map(key => [key, Object.getOwnPropertyDescriptor(globalThis, key)]));
const hooks = registerHooks({ resolve(specifier, context, nextResolve) {
  if (specifier === './calcit.build-errors') specifier += '.mjs';
  if (specifier === 'virtual-dom/create-element') specifier += '.js';
  return nextResolve(specifier, context);
} });
let app, main, grow, util, demoState;
try {
  globalThis.window = { navigator: { userAgent: 'Node regression fixture' }, innerWidth: 800, innerHeight: 600, addEventListener() {} };
  globalThis.document = { createElement() { return { getContext() { return { measureText(text) { return { width: text.length }; } }; } }; } };
  app = await import('../js-out/app.comp.container.mjs');
  main = await import('../js-out/app.main.mjs');
  grow = await import('../js-out/app.comp.grow-demo.mjs');
  util = await import('../js-out/app.util.mjs');
  demoState = (await import('../js-out/phlox.core.mjs'))._GT__GT_;
} finally {
  hooks.deregister();
  for (const [key, descriptor] of Object.entries(previous)) {
    if (descriptor) Object.defineProperty(globalThis, key, descriptor);
    else Reflect.deleteProperty(globalThis, key);
  }
}
const t = c.init_tags(['tab', 'tree', 'states', 'cursor', 'data', 'touch', 'touch-key', 'name', 'props', 'children', 'ops', 'move-to', 'line-to', 'bezier-to', 'p1', 'p2', 'to-p', 'on', 'pointertap', 'editor']);
const read = (value, tag) => c.option_$o_unwrap(c.get(value, tag));
const nth = (value, index) => c.option_$o_unwrap(c.nth(value, index));
const op = (tag, ...args) => c._$o__$o_(tag, ...args);
function nodes(node, found = []) {
  // Raw DSL includes absent conditional children. This is a drawing-data walk,
  // not a claim that the WebGL renderer has been exercised.
  if (node === null) return found;
  assert.ok(c.map_$q_(node) || c.struct_$q_(node), 'Real Phlox node is a Map or nominal Struct');
  found.push(node);
  const children = c.get(node, t.children);
  if (c.option_$o_some_$q_(children)) for (const pair of c.option_$o_unwrap(children).toArray()) nodes(nth(pair, 1), found);
  return found;
}
function checkDrawing(root) {
  let count = 0;
  for (const node of nodes(root)) {
    const props = c.get(node, t.props);
    if (c.option_$o_none_$q_(props)) continue;
    const ops = c.get(c.option_$o_unwrap(props), t.ops);
    if (c.option_$o_none_$q_(ops)) continue;
    for (const operation of c.option_$o_unwrap(ops).toArray()) {
      const tag = nth(operation, 0);
      if (tag === t['move-to'] || tag === t['line-to']) {
        const point = nth(operation, 1);
        assert.ok(c.list_$q_(point), `Expected a coordinate List, not Option: ${c.format_cirru_edn(point)}`);
        assert.equal(c.count(point), 2);
        assert.ok(point.toArray().every(Number.isFinite));
        count++;
      }
      if (tag === t['bezier-to']) {
        for (const key of [t.p1, t.p2, t['to-p']]) {
          const point = read(nth(operation, 1), key);
          assert.ok(c.list_$q_(point), 'Bézier control points must not remain Options');
          assert.equal(c.count(point), 2);
          assert.ok(point.toArray().every(Number.isFinite));
        }
        count++;
      }
    }
  }
  return count;
}
for (const tab of app.tabs.toArray()) {
  test(`actual ${tab.value} tab builds finite drawing data with unwrapped coordinates`, async () => {
    const demoModule = await import(`../js-out/app.comp.${tab.value}-demo.mjs`);
    const priorDocument = globalThis.document, priorRandom = Math.random;
    let seed = 1597;
    try {
      // Deterministic host entropy, not replaced drawing functions or algorithms.
      Math.random = () => { seed = (Math.imul(seed, 1664525) + 1013904223) >>> 0; return seed / 4294967296; };
      globalThis.document = { createElement() { return { getContext() { return { measureText(text) { return { width: text.length }; } }; } }; } };
      const root = app.comp_container(c.assoc(store, t.tab, tab));
      const selected = nth(nth(read(root, t.children), 1), 1);
      const demo = nth(nth(read(selected, t.children), 0), 1);
      seed = 1597;
      const stateful = ['tree', 'rotate', 'bezier', 'cycloid', 'chord', 'oscillo', 'geocentric', 'snowflake', 'harmono', 'satellite'].includes(tab.value);
      const expected = demoModule[`comp_${tab.value}_demo`](stateful ? demoState(read(store, t.states), tab) : c.option_$o_unwrap_or(c.get(store, t['touch-key']), null));
      const actualNodes = nodes(demo), expectedNodes = nodes(expected);
      assert.ok(actualNodes.length > 1, 'Selected demo must contain drawing nodes');
      assert.equal(actualNodes.length, expectedNodes.length, 'Selected branch must produce its actual demo, not navigation or fallback');
      for (let i = 0; i < actualNodes.length; i++) {
        assert.equal(read(actualNodes[i], t.name), read(expectedNodes[i], t.name));
      }
      checkDrawing(demo);
    } finally {
      Math.random = priorRandom;
      if (priorDocument === undefined) delete globalThis.document; else globalThis.document = priorDocument;
    }
  });
}
test('actual tab click emits one Enum and the real main dispatcher updates the Store', () => {
  const before = c.deref(main._$s_store);
  const node = app.comp_tab('Tree', t.tree, 0, false);
  const rect = nth(nth(read(node, t.children), 0), 1);
  const callback = read(read(read(rect, t.props), t.on), t.pointertap);
  try {
    let calls = 0;
    callback(null, (...args) => {
      assert.equal(args.length, 1);
      assert.ok(c.enum_$q_(args[0]));
      main.dispatch_$x_(args[0]);
      calls++;
    });
    assert.equal(calls, 1);
    assert.equal(read(c.deref(main._$s_store), t.tab), t.tree);
    main.dispatch_$x_(op(t.states, c._$L_(t.editor), 'Draft'));
    assert.equal(read(read(read(c.deref(main._$s_store), t.states), t.editor), t.data), 'Draft');
  } finally { c.reset_$x_(main._$s_store, before); }
});
test('real states and touch Enums preserve the original selected tab and state data', () => {
  const selected = updater(store, op(t.tab, t.tree), 'fixture', 0);
  const next = updater(selected, op(t.states, c._$L_(t.editor), 'Draft'), 'fixture', 0);
  assert.equal(read(read(read(next, t.states), t.editor), t.data), 'Draft');
  assert.equal(read(next, t.tab), t.tree);
  assert.equal(read(updater(next, op(t.touch, null), 'fixture', 0), t['touch-key']), null);
  assert.equal(c.option_$o_none_$q_(c.get(read(store, t.states), t.editor)), true);
});
test('all three pick-many branches retain raw coordinates rather than nested Options', () => {
  const random = Math.random;
  const points = c._$L_(c._$L_(0, 0), c._$L_(1, 0), c._$L_(0, 1));
  try {
    for (const [entropy, indices] of [[0, [1, 2]], [0.4, [0, 2]], [0.8, [0, 1]]]) {
      Math.random = () => entropy;
      const picked = grow.pick_many(points);
      assert.equal(c.count(picked), 2);
      for (let i = 0; i < 2; i++) assert.ok(c._$e_(nth(picked, i), nth(points, indices[i])));
    }
  } finally { Math.random = random; }
  assert.equal(c.count(grow.pick_many(c._$L_())), 0);
});
test('actual vector helpers preserve complex multiplication and coordinate arithmetic', () => {
  const a = c._$L_(3, 4), b = c._$L_(2, -1);
  assert.deepEqual(util.add_path(a, b).toArray(), [5, 3]);
  assert.deepEqual(util.subtract_path(a, b).toArray(), [1, 5]);
  assert.deepEqual(util.multiply_path(a, b).toArray(), [10, 5]);
  assert.deepEqual(util.invert_y(a).toArray(), [3, -4]);
});
