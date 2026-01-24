https://www.hackerrank.com/challenges/weather-observation-station-20/problem?isFullScreen=true


# 1단계

```sql
SELECT
    LAT_N,
    ROW_NUMBER() OVER (ORDER BY LAT_N) AS rn, --LAT_N을 정렬 기준으로 삼아서 → 각 행에 1,2,3,... 순번(rn) 을 붙여라
    COUNT(*) OVER () AS cnt -- 행 개수 그대로 유지→ 각 행마다 cnt=100 이 붙는다.
FROM STATION
```


<img width="187" height="288" alt="image" src="https://github.com/user-attachments/assets/6f2d5cd5-537c-4aab-8ba6-3dd1d069b936" />


---

# 2단계 : 중앙값에 해당하는 rn(행 번호) 계산

각 행에
- 정렬 순번 rn
- 전체 행 개수 cnt
를 윈도우 함수를 사용해서 붙임.

이제 정렬된 데이터에서 중앙에 위치한 rn 값만 골라야 함.

### 중앙값 구하기

```sql
FLOOR((cnt + 1) / 2)
FLOOR((cnt + 2) / 2)
```
-이 두 식은 홀수 / 짝수 경우를 모두 자동 처리함

### cnt가 홀수일 때
```sql
FLOOR((499 + 1) / 2) = FLOOR(500/2) = 250
FLOOR((499 + 2) / 2) = FLOOR(501/2) = 250
```
- 둘 다 rn = 250 => 중앙 행 1개 선택

### cnt가 짝수일 때
```sql
FLOOR((500 + 1) / 2) = FLOOR(501 / 2) = FLOOR(250.5) = 250
FLOOR((500 + 2) / 2) = FLOOR(502 / 2) = FLOOR(251)   = 251
```
- rn = 250, 251
정렬된 데이터에서 250번째와 251번째 값이 중앙값 후보가 된다.
이 두 값의 평균을 내면 Median 이 된다.

### 따라서 중앙값 후보 선택 조건은 이렇다
```sql
WHERE rn IN (
  FLOOR((cnt + 1) / 2),
  FLOOR((cnt + 2) / 2)
)
```
---
# 3단계 : 중앙값 계산 및 반올림
선택된 중앙값 후보 LAT_N 값들에 대해
- 홀수 → 1개 값
- 짝수 → 2개 값
을 AVG()로 평균 내면 Median 이 된다.

```sql
SELECT ROUND(AVG(LAT_N), 4) AS median_lat_n
FROM (
    SELECT
        LAT_N,
        ROW_NUMBER() OVER (ORDER BY LAT_N) AS rn,
        COUNT(*) OVER () AS cnt
    FROM STATION
) t
WHERE rn IN (
    FLOOR((cnt + 1) / 2),
    FLOOR((cnt + 2) / 2)
);

```
