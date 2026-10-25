# macOS 27 灰度设置指南

## 问题背景

在 macOS 27 (Golden Gate) 上，传统的灰度滤镜 API（`CGDisplayForceToGray`、`MADisplayFilterPrefSetType` 等）**无法影响 Dock 和菜单栏**。这是因为苹果将系统 UI 的合成层与应用内容分离了。

## 解决方案

使用 **Shortcuts 快捷指令** 来切换灰度，这是目前唯一能让 Dock 和菜单栏也变灰的方法。

## 设置步骤

### 1. 打开 Shortcuts 应用

在 Launchpad 或 Applications 文件夹中找到 **Shortcuts** 应用并打开。

### 2. 创建快捷指令

1. 点击左上角的 **"+"** 按钮创建新快捷指令
2. 搜索并添加 **"Set Color Filters"**（设置色彩滤镜）动作
3. 配置：
   - **Filter**: Grayscale（灰度）
   - **Enabled**: 勾选
4. 点击右上角的下拉菜单，选择 **"Rename"**
5. 命名为：**"Enable Grayscale"**
6. 保存

### 3. 创建关闭灰度的快捷指令

1. 再次点击 **"+"** 创建新快捷指令
2. 添加 **"Set Color Filters"** 动作
3. 配置：
   - **Filter**: Grayscale（灰度）
   - **Enabled**: **取消勾选**
4. 命名为：**"Disable Grayscale"**
5. 保存

### 4. 验证快捷指令

在终端中运行：

```bash
shortcuts run "Enable Grayscale"
```

检查 Dock 和菜单栏是否变灰。

## 技术说明

修改后的 `Grayscale.swift` 在 macOS 27+ 上会优先尝试使用 `shortcuts` 命令：

```swift
if #available(macOS 27.0, *) {
    if runShortcutsGrayscale(enable: true) {
        return  // 成功，直接返回
    }
}
// 失败则回退到传统方式
```

## 注意事项

- 快捷指令名称必须严格匹配："Enable Grayscale" 和 "Disable Grayscale"
- 如果快捷指令不存在，app 会回退到传统方式（只影响应用窗口）
- 需要授予 app **辅助功能权限**（Accessibility）

## 替代方案

如果 Shortcuts 方案不可用，还可以：

1. **手动设置**：System Settings → Accessibility → Display → Color Filters
2. **使用快捷键**：Control + Option + Command + 8（如果已启用）
3. **使用第三方工具**：如 [Gray](https://github.com/zenangst/Gray) 或 [Grayscale Mode](https://github.com/rkbhochalya/grayscale-mode)
