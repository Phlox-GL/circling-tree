
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

本地不设置 `VITE_BASE_URL` 时仍使用相对路径。上传与公开访问校验仅使用 COS Action 内置 verify，不添加额外 CDN 校验脚本。CI 保留入口严格检查、全部公共定义检查和编译构建，不重复运行迁移预览与类型债务报告。运行测试仅保留真实 dispatcher、状态更新和向量运算三个检查，不代表真实 WebGL 截图验收。组件明确返回 `phlox.schema/PhloxElement`；页签参数使用 String/Tag/Number/Bool，字形编号为 Number，重置按钮坐标为 List<Number>。列表 helper 使用泛型保持元素类型，config/数值初始状态及 updater 的 ID/时间参数均有明确类型。Phlox/Touch Control 传递 js-ffi 版本请求仍有冲突，开放状态和宿主边界尚有 Dynamic，不宣称严格 Caps 或全部类型债务清零。原共享字体、图标及服务器部署路径不变。

### Inspired by...

* https://twitter.com/Sladix/status/1226103884516601856
* https://twitter.com/MAKIO135/status/1227474413362110464

### Workflow

Workflow https://github.com/mvc-works/phlox-workflow

### License

MIT
