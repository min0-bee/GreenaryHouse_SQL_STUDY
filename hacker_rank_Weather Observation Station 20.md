https://www.hackerrank.com/challenges/weather-observation-station-20/problem?isFullScreen=true

# 1단계 : 중앙값은 “1개”일까 “2개”일까? (홀/짝)
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


# 2단계
- `offset` 함수로 중앙값 찾기
- OFFSET N = "정렬된 결과에서 앞의 N개 행을 건너뛰고 그 다음부터 가져와라"

```sql
SELECT (COUNT(*) - 1) / 2
FROM STATION;
```


```sql
(COUNT(*) - 1) / 2
```
- 중앙값이 시작되는 인덱스 위치

## OFFSET 계산식 `(COUNT(*) - 1) / 2` 는 왜 이렇게 생겼을까?

중앙값을 구하기 위해서는  
정렬된 데이터에서 **중앙값이 시작되는 위치(OFFSET)** 를 정확히 계산해야 한다.  

OFFSET은 **0번 인덱스 기준으로 앞에서 몇 개를 건너뛸지**를 의미한다.

---

###  1) 데이터 개수가 홀수일 때

예: COUNT = 5

| Index (0-base) | 값 |
|----------------|----|
| 0 | A |
| 1 | B |
| 2 | C ← 중앙값 |
| 3 | D |
| 4 | E |

우리가 원하는 OFFSET = **2**

계산식: (COUNT - 1) / 2
= (5 - 1) / 2
= 2


→ OFFSET 2  
→ 정확히 중앙 인덱스가 선택된다.

---

# 2단계

```sql
SELECT
    LAT_N,
    ROW_NUMBER() OVER (ORDER BY LAT_N) AS rn, --LAT_N을 정렬 기준으로 삼아서 → 각 행에 1,2,3,... 순번(rn) 을 붙여라
    COUNT(*) OVER () AS cnt -- 행 개수 그대로 유지→ 각 행마다 cnt=100 이 붙는다.
FROM STATION
```


<img width="187" height="288" alt="image" src="https://github.com/user-attachments/assets/6f2d5cd5-537c-4aab-8ba6-3dd1d069b936" />


---

