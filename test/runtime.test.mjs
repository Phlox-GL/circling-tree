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
let app, main, util;
try {
  globalThis.window = { navigator: { userAgent: 'Node regression fixture' }, innerWidth: 800, innerHeight: 600, addEventListener() {} };
  globalThis.document = { createElement() { return { getContext() { return { measureText(text) { return { width: text.length }; } }; } }; } };
  app = await import('../js-out/app.comp.container.mjs');
  main = await import('../js-out/app.main.mjs');
  util = await import('../js-out/app.util.mjs');
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
test('actual vector helpers preserve complex multiplication and coordinate arithmetic', () => {
  const a = c._$L_(3, 4), b = c._$L_(2, -1);
  assert.deepEqual(util.add_path(a, b).toArray(), [5, 3]);
  assert.deepEqual(util.subtract_path(a, b).toArray(), [1, 5]);
  assert.deepEqual(util.multiply_path(a, b).toArray(), [10, 5]);
  assert.deepEqual(util.invert_y(a).toArray(), [3, -4]);
});
