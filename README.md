
Circling Tree(WIP)
----

> Rendering tree patterns

### Usage

WIP

使用配对正式 Calcit/procs 0.30.1、Node.js 24 与 Yarn 4.18.0。模块固定已发布正式 tag Phlox 0.7.16、Touch Control 0.0.32、js-ffi 0.2.5，严格 Caps 安装，不使用本地候选或提交 hash。绘图公式、状态合同及已有 `hud!` 热更新提示保持不变；全屏边界复用 JS-FFI 的真实 DOM 校验及 Unit 适配器，删除本地重复 trait 和最后一处 unsafe。仅维护 `calcit.cirru` / `deps.cirru`，CI 禁止旧 `compact.cirru` / `package.cirru` 回流。

Pixi 保持 7.x，固定正式 7.4.3：旧 7.2.4 的 assets 包要求 umbrella 包未提供的 utils peer，7.4.3 已修正该声明。复用上游正式修复，不加 packageExtensions、重复 utils 依赖或忽略 peer 警告；升级后的实际图形仍需单独验收。

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

组件和绘图 helper 返回真实 `phlox.schema/PhloxElement`，操作使用已有 nominal `app.schema/Op`，store 与业务 data 仍为 `Map<Tag, Dynamic>`。状态树的 key 混合 Tag 元数据、数字索引及字符串分支，因此其边界如实声明 `Map<Dynamic, Dynamic>`；`child-states` 直接调用 Phlox `>>`，不再伪造 Fn，也不转换 key 类型。Number、坐标和宿主标量使用实际值检查，全屏输入在真实 DOM 边界校验，应用源码 unsafe 为零，不宣称零 Dynamic。默认值、刷新 Nil、随机调用参数/顺序（包括零参数 rand 的 0–100 区间）及绘图公式保持；不新增 compiler 特例或放宽门禁。

### Inspired by...

* https://twitter.com/Sladix/status/1226103884516601856
* https://twitter.com/MAKIO135/status/1227474413362110464

### Workflow

Workflow https://github.com/mvc-works/phlox-workflow

### License

MIT
