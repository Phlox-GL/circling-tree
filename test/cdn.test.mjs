import assert from 'node:assert/strict';
import test from 'node:test';
import { readFileSync, existsSync } from 'node:fs';
import { resolve } from 'node:path';
const base = process.env.VITE_BASE_URL;
assert.ok(base, 'VITE_BASE_URL must be supplied');
assert.ok(base.endsWith('/'));
assert.equal(new URL(base).protocol, 'https:');
const html = readFileSync(new URL('../dist/index.html', import.meta.url), 'utf8');
const assets = [...html.matchAll(/<(?:script|link)\b[^>]*>/g)].flatMap(([tag]) => {
  const url = /\b(?:src|href)="([^"]+)"/.exec(tag)?.[1];
  return url && /\/assets\/[^/?#]+\.(?:js|css)(?:[?#].*)?$/.test(url) ? [url] : [];
});
test('actual entry JS/CSS use the precise frontend CDN prefix and exist locally', () => {
  assert.ok(assets.some(url => /\.js$/.test(url)));
  assert.ok(assets.some(url => /\.css$/.test(url)));
  for (const url of assets) {
    assert.ok(url.startsWith(`${base}assets/`), `Incorrect CDN asset: ${url}`);
    assert.ok(existsSync(resolve('dist', url.slice(base.length))));
  }
});
test('original shared fonts, logo and title remain unchanged', () => {
  assert.ok(html.includes('href="https://cdn.tiye.me/favored-fonts/main-fonts.css"'));
  assert.ok(html.includes('href="https://cdn.tiye.me/logo/quamolit.png"'));
  assert.ok(html.includes('<title>Circling Tree</title>'));
});
