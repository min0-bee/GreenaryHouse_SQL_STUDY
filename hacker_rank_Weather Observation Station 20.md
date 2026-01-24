https://www.hackerrank.com/challenges/weather-observation-station-20/problem?isFullScreen=true

### 왜 `SELECT 2 - (COUNT(*) % 2)` 의 결과가 1일까?

```sql
SELECT 2 - (COUNT(*) % 2)
FROM STATION;
```

### 결과
```sql
1
```

이 결과는 STATION 테이블의 전체 행 개수(COUNT(*))가 홀수라는 뜻이다.

| COUNT(*) | COUNT(*) % 2 | 의미   |
| -------- | ------------ | ---- |
| 짝수       | 0            | even |
| 홀수       | 1            | odd  |

