# Claude Code + ChatGPT OAuth 설정

이 문서는 `https://github.com/router-for-me/CLIProxyAPI`를 Claude Code와 함께 쓰기 위한 최소 설정만 정리합니다.

## 필요한 폴더 구조

같은 작업공간 아래에 `codex_proxy_for_claudecode`와 `https://github.com/router-for-me/CLIProxyAPI` 체크아웃이 함께 있어야 합니다.

## 설정 방법

1. `https://github.com/router-for-me/CLIProxyAPI`를 clone 하거나 갱신하고 심볼릭 링크를 만듭니다.

```bash
./scripts/bootstrap.sh
```

2. 셸 헬퍼를 불러옵니다.

```bash
source ./shell/claude_code_proxy.sh
```

3. 프록시를 시작합니다.

```bash
CC_PROXY
```

4. 상태를 확인합니다.

```bash
CC_PROXY_STATUS
```

5. 사용을 끝내면 종료합니다.

```bash
CC_PROXY_STOP
```

## 참고

- `HELP`는 프록시 단축 명령과 현재 심볼릭 링크 경로를 보여줍니다.
- `CLI_PROXYAPI_DIR`를 설정하면 `https://github.com/router-for-me/CLIProxyAPI` 위치를 직접 지정할 수 있습니다.
