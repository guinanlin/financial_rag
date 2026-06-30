# RAG 知识库系统 - 项目规范

## 项目概述

面向财税法务专业领域的 RAG（Retrieval-Augmented Generation）知识库平台，采用 FastAPI + Vue 3 前后端分离架构，支持多智能体协作、知识图谱增强和 12 家 LLM 全适配。

## 技术栈

### 前端 (rag_frontend)
- **框架**: Vue 3.4+ + TypeScript
- **构建工具**: Vite
- **UI 组件**: Element Plus
- **状态管理**: Pinia
- **路由**: Vue Router 4
- **样式**: Tailwind CSS
- **包管理器**: pnpm（平台要求）

### 后端 (rag_backend)
- **框架**: FastAPI 0.128+
- **Python**: 3.12+
- **数据库**: PostgreSQL 16+ (pgvector)
- **图数据库**: Neo4j 5.15
- **AI 框架**: LangGraph, 自研 Agent Framework
- **迁移工具**: Alembic
- **包管理**: requirements.txt + uv

### MCP Server (mcp_server)
- **框架**: Python MCP Server
- **用途**: Model Context Protocol 工具服务

## 目录结构

```
/workspace/projects/
├── .coze                    # 根配置（平台读取入口）
├── AGENTS.md                # 本文件
├── 530.sql                  # 数据库初始化脚本
├── rag_frontend/            # Vue 3 前端项目
│   ├── .coze               # 子项目配置
│   ├── src/                # 源代码
│   ├── package.json        # 依赖配置
│   └── vite.config.ts      # Vite 配置
├── rag_backend/             # FastAPI 后端项目
│   ├── .coze               # 子项目配置
│   ├── app/                # 应用代码
│   ├── alembic/            # 数据库迁移
│   ├── requirements.txt    # Python 依赖
│   └── docker-compose.yml  # Docker 编排
└── mcp_server/              # MCP 工具服务
    ├── .coze               # 子项目配置
    ├── app/                # 应用代码
    └── requirements.txt    # Python 依赖
```

## 关键入口 / 核心模块

### 前端入口
- **开发服务器**: `pnpm dev` (端口 5500)
- **构建**: `pnpm build`
- **入口文件**: `rag_frontend/src/main.ts`
- **路由配置**: `rag_frontend/src/router/`

### 后端入口
- **主应用**: `rag_backend/app/main.py`
- **API 路由**: `rag_backend/app/api/`
- **核心服务**: `rag_backend/app/services/`
- **Agent 系统**: `rag_backend/app/multi_agent_system/`

### MCP Server
- **入口**: `mcp_server/app/main.py`

## 运行与预览

### 前端预览
- 项目类型: web，支持预览
- 预览端口: 5000（平台统一）
- 开发端口: 5500（vite.config.ts 配置）

### 后端服务
- 默认端口: 8000
- API 文档: `/docs` (Swagger UI)
- 需要 PostgreSQL 和 Neo4j 支持

### 代理配置
前端 Vite 已配置代理：
- `/api` → `http://localhost:8000`
- `/ws-api` → `http://localhost:8000` (WebSocket)

## 用户偏好与长期约束

1. **包管理器**: Node.js 项目必须使用 pnpm，禁止 npm/yarn
2. **Python 环境**: 使用 uv 管理虚拟环境
3. **端口规范**: 预览统一使用 5000，禁止使用 9000
4. **代码风格**: Python 使用 ruff（配置见 pyproject.toml）
5. **数据库迁移**: 使用 Alembic 管理

## 常见问题和预防

1. **端口冲突**: 前端开发端口 5500，预览端口 5000，后端 8000
2. **依赖安装**: 前端使用 pnpm install，后端使用 uv pip install -r requirements.txt
3. **环境变量**: 后端需要配置 .env 文件（参考 .env.example）
4. **数据库**: 需要先执行 530.sql 初始化数据库结构

## 预览链路配置

### 项目判断
- rag_frontend 被判定为 Web 预览型项目（Vue 3 + Vite 前端应用）
- rag_backend 和 mcp_server 是后端服务，不支持预览

### 预览入口
- **根 .coze**: `[dev].build` → `rag_frontend/scripts/coze-preview-build.sh`
- **根 .coze**: `[dev].run` → `rag_frontend/scripts/coze-preview-run.sh`
- **子项目 rag_frontend/.coze**: `[dev].build` → `scripts/coze-preview-build.sh`
- **子项目 rag_frontend/.coze**: `[dev].run` → `scripts/coze-preview-run.sh`

### 预览脚本说明
- `coze-preview-build.sh`: 安装 pnpm 依赖
- `coze-preview-run.sh`: 先构建前端产物，然后启动 Vite preview 服务器，绑定 0.0.0.0:5000

### 注意事项
- 预览服务必须在 5000 端口运行，绑定 0.0.0.0
- 脚本具有幂等性，会先清理 5000 端口残留进程
- Vite preview 模式支持代理配置，将 `/api` 和 `/ws-api` 转发到后端 8000 端口
- 相比 Vite dev 模式，preview 模式更稳定，不会在 Coze 代理环境下出现空白页问题

## 部署配置

### 项目识别
- **repo_type**: web
- **deploy_kind**: service
- **deploy_flavor**: web
- **project_entrypoint**: rag_frontend/index.html
- **runtime_requires**: nodejs-24
- **service_port**: 5000

### 部署入口
- **根 .coze**: `[deploy].build` → `rag_frontend/scripts/build.sh`
- **根 .coze**: `[deploy].run` → `rag_frontend/scripts/run.sh`
- **子项目 rag_frontend/.coze**: `[deploy].build` → `scripts/build.sh`
- **子项目 rag_frontend/.coze**: `[deploy].run` → `scripts/run.sh`

### 部署脚本说明
- `build.sh`: 安装依赖并构建前端产物（pnpm install + vite build）
- `run.sh`: 使用 serve 提供静态文件服务，端口 5000

### 注意事项
- 部署时构建产物输出到 `dist/` 目录
- run.sh 使用 `npx serve dist -l 5000` 提供静态文件服务
- 部署环境需要 Node.js 24 运行时
