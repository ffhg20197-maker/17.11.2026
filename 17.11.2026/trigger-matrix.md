# Матрица проверки триггеров

| № | Сценарий | Ожидаемый результат |
|---|---|---|
| 1 | push index.html в main | basic-trigger запускается |
| 2 | push только README.md в main | basic-trigger не запускается |
| 3 | push src/** в feature/demo | feature-ci запускается |
| 4 | push src/** в feature/wip | feature-ci не запускается |
| 5 | PR в main с изменением src/** | feature-ci запускается |
| 6 | commit message содержит [skip ci] | push/PR workflow run пропускается |
| 7 | push tag v1.0.0 | release-pipeline запускается |
| 8 | push tag v1.0.0-beta1 | release-pipeline не запускается |
| 9 | PR opened/synchronize/closed | release-pipeline запускается на указанные types |
| 10 | PR closed, merged=true | deploy job запускается |
| 11 | PR closed, merged=false | deploy job пропускается |
| 12 | workflow_dispatch | workflow запускается вручную; deploy без тега/merge пропускается |

## Критерии
Синтаксис YAML; branches/negative glob; paths без конфликтующих paths-ignore; tags и pull_request.types; workflow_dispatch; проверка в Actions и [skip ci]; комментарии и читаемые имена.
