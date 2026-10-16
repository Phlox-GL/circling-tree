
Circling Tree(WIP)
----

> Rendering tree patterns

### Usage

WIP

使用配对 Calcit/procs 0.30.1-alpha.4、Node.js 24 与 Yarn 4.18.0；0.30.1 尚无稳定版，不将 alpha 写成正式版。模块要求 Phlox 0.7.15、Touch Control 0.0.31、js-ffi 0.2.3；迁移分支需等 Phlox 0.7.15 正式 tag 发布后才可独立安装。仅维护 `calcit.cirru` / `deps.cirru`，CI 禁止旧 `compact.cirru` / `package.cirru` 回流。

```bash
caps --strict --ci
yarn install --immutable
caps verify --toolchain
calcit calcit.cirru --check-only --all-defs
calcit calcit.cirru fix --workflow strict --verify
VITE_BASE_URL=https://cos-sh.tiye.me/Phlox-GL/circling-tree/ yarn build
```

`yarn build` 包含一次编译；`yarn dev` 先生成初始 JS 再启动 Vite，修改 Calcit 时在另一终端运行 `yarn watch`，无需 concurrently。PR 资源按 `pr/<编号>/<run>/<attempt>/` 隔离，生产路径不变。COS Action 使用正式 v1.2.0；生产部署排队且不取消，发布前检查当前 main，过期构建同时跳过 COS 与原服务器同步。

本地不设置 `VITE_BASE_URL` 时仍使用相对路径。上传与公开访问校验仅使用 COS Action 内置 verify，不添加额外 CDN 校验脚本。CI 保留全定义、公共定义、完整 strict 和原构建，不重复迁移预览/债务报告，也不新建测试框架。原项目没有附带单元测试；浏览器交互仍须单独验收，不能用编译成功代替。共享字体、图标、生产 COS/CDN 与服务器部署路径不变。

组件和绘图 helper 返回真实 `phlox.schema/PhloxElement`，操作使用已有 nominal `app.schema/Op`，store 与业务 data 仍为 `Map<Tag, Dynamic>`。状态树的 key 混合 Tag 元数据、数字索引及字符串分支，因此其边界如实声明 `Map<Dynamic, Dynamic>`；`child-states` 直接调用 Phlox `>>`，不再伪造 Fn，也不转换 key 类型。Number、坐标和宿主标量使用实际值检查，保留真实 fullscreen 对象身份的一处 unsafe 边界，不宣称零 Dynamic。默认值、刷新 Nil、随机调用参数/顺序（包括零参数 rand 的 0–100 区间）及绘图公式保持；不新增 compiler 特例或放宽门禁。

### Inspired by...

* https://twitter.com/Sladix/status/1226103884516601856
* https://twitter.com/MAKIO135/status/1227474413362110464

### Workflow

Workflow https://github.com/mvc-works/phlox-workflow

### License

MIT
