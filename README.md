
Circling Tree(WIP)
----

> Rendering tree patterns

### Usage

WIP

使用 Calcit/procs 0.27.0、Node.js 24 与 Yarn 4.18.0。仅维护 `calcit.cirru` / `deps.cirru`，CI 禁止旧 `compact.cirru` / `package.cirru` 回流。

```bash
caps --ci
yarn install --immutable
calcit calcit.cirru --check-only
yarn compile
VITE_BASE_URL=https://cos-sh.tiye.me/Phlox-GL/circling-tree/pr/52/ yarn build
node --test test/runtime.test.mjs
```

本地不设置 `VITE_BASE_URL` 时仍使用相对路径。上传与公开访问校验使用 COS Action 内置 verify 配置，不添加额外 CDN 校验脚本。功能测试使用真实编译组件/Phlox 绘图数据和浏览器宿主 fixture，不代表真实 WebGL 截图验收。Phlox/Touch Control 传递 js-ffi 版本请求仍有冲突，不宣称严格 Caps 通过。原共享字体、图标及服务器部署路径不变。

### Inspired by...

* https://twitter.com/Sladix/status/1226103884516601856
* https://twitter.com/MAKIO135/status/1227474413362110464

### Workflow

Workflow https://github.com/mvc-works/phlox-workflow

### License

MIT
