# Статус подтверждения

## Проверено по содержимому репозитория
- Все три workflow созданы в .github/workflows/.
- Базовый workflow ограничен main и **.html.
- Feature workflow содержит feature/**, исключение !feature/wip, PR target main и src/**.
- Release workflow содержит SemVer tags, исключение beta, PR types и workflow_dispatch.
- Deploy condition требует релизный тег без beta или закрытый merged PR.

## Требует событий в GitHub
Фактические workflow runs, отсутствие запуска при README-only push, skip ci, tag run и PR merge run должны подтверждаться во вкладке Actions после создания соответствующих событий. Конфигурация сама по себе не является доказательством выполнения.
