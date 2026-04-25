# codex_proxy_for_claudecode

Codex OAuth 계정을 활용해 Claude Code 툴을 사용하기 위한 셸 도우미와 설정 메모를 모아둔 프로젝트입니다.

## 구성

- `shell/claude_code_proxy.sh`: `source` 해서 쓰는 셸 헬퍼
- `scripts/bootstrap.sh`: `https://github.com/router-for-me/CLIProxyAPI` clone/pull 후 로컬 심볼릭 링크 생성
- `docs/claude-code-chatgpt-oauth-101.md`: 설정 가이드

## 빠른 시작

```bash
./scripts/bootstrap.sh
source ./shell/claude_code_proxy.sh
HELP
```

## 전제

- 이 폴더는 `codex_proxy_for_claudecode` 작업공간에 둡니다.
- bootstrap 스크립트가 같은 작업공간의 상대경로 `../CLIProxyAPI`에 `https://github.com/router-for-me/CLIProxyAPI`를 clone 하거나 갱신한 뒤, 로컬 `CLIProxyAPI` 심볼릭 링크로 참조합니다.
- 실제 프록시 코드는 이 저장소에 포함하지 않습니다.
