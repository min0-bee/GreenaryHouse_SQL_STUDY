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

이제 정렬된 데이터에서 중앙에 위치한 rn 값만 골라야 한다.

