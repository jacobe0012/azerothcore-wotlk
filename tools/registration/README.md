# ac-register — 玩家自助注册页

一个 Docker 化的注册网页容器，基于上游 [masterking32/WoWSimpleRegistration](https://github.com/masterking32/WoWSimpleRegistration) (GPL-3.0)。暴露一个 HTTP 端口，玩家在浏览器里填用户名/密码即可建账号，免除手动 `docker exec` 插表。

## 用法

1. 在仓库根目录的 `.env` 里加（示例）：

   ```env
   REGISTER_PORT=8080
   REGISTER_REALM_NAME=Jacoo的服务器
   REGISTER_REALMLIST=192.168.1.10
   REGISTER_BASE_URL=http://192.168.1.10:8080
   REGISTER_CAPTCHA_TYPE=0
   ```

   `REGISTER_REALMLIST` 填玩家 `realmlist.wtf` 里写的那个地址。
   `REGISTER_BASE_URL` 填你 LAN 访问注册页的地址。

2. 启动：

   ```bash
   docker compose up -d --build ac-register
   ```

3. 浏览器访问 `http://<LAN-IP>:8080`，中文注册页会自动加载。

## 环境变量

| 变量 | 默认值 | 说明 |
|---|---|---|
| `REGISTER_PORT` | `8080` | host 上暴露的端口 |
| `REGISTER_BASE_URL` | `http://localhost:8080` | 页面自身的 URL，影响图片/静态资源加载路径 |
| `REGISTER_PAGE_TITLE` | `AzerothCore Register` | 浏览器标签页标题 |
| `REGISTER_DEFAULT_LANGUAGE` | `chinese-simplified` | 默认语言 |
| `REGISTER_REALMLIST` | `127.0.0.1` | 注册成功页显示给玩家的 realmlist 地址 |
| `REGISTER_REALM_NAME` | `AzerothCore` | realm 展示名 |
| `REGISTER_CAPTCHA_TYPE` | `0` | `0`=服务端图形验证码（离线可用，推荐）；`1`=hCaptcha；`2`=reCaptcha v2；`3`=Cloudflare Turnstile；`>3`=关闭 |
| `REGISTER_CAPTCHA_KEY` | 空 | 1/2/3 时填对应的 site key |
| `REGISTER_CAPTCHA_SECRET` | 空 | 1/2/3 时填对应的 secret key |
| `REGISTER_DEBUG_MODE` | `false` | `true` 开调试（白屏/报错时临时打开） |

数据库相关变量（通常不用改）：
`DB_HOST=ac-database`, `DB_PORT=3306`, `DB_USER=root`, `DB_PASSWORD=${DOCKER_DB_ROOT_PASSWORD}`, `AUTH_DB_NAME=acore_auth`, `CHAR_DB_NAME=acore_characters`。

## 升级上游版本

改 `docker-compose.override.yml` 里 `ac-register` 服务的 `build.args.WSR_VERSION`（或 `Dockerfile` 里的 `ARG WSR_VERSION`），然后：

```bash
docker compose build --no-cache ac-register
docker compose up -d ac-register
```

## 合规

上游 WoWSimpleRegistration 为 GPL-3.0。容器内保留原 LICENSE。我们没有修改上游源码，只添加 `config.php.tpl` 与 `entrypoint.sh` 做运行时配置。

## 排障

- **白屏 / 500**：设 `REGISTER_DEBUG_MODE=true` 重启容器，`docker logs ac-register` 或浏览器看栈
- **DB connection refused**：确认 `ac-database` 容器已起，且 `DB_PASSWORD` 与 `.env` 的 `DOCKER_DB_ROOT_PASSWORD` 一致
- **图片/CSS 404**：`REGISTER_BASE_URL` 没填对，必须是玩家浏览器实际访问的 URL 根
