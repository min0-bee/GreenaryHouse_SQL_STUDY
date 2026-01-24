https://www.hackerrank.com/challenges/average-population-of-each-continent/problem?isFullScreen=true
- level : basic join
FLOOR() 함수 : 소숫점 아래를 버리고 가장 가까운 작은 정수로 내림한다
- 12.9 => FLOOR(12.9) => 12
- -3.2 => FLOOR(-3.2) => -4

# 1단계 : CITY와 COUNTRY 테이블을 JOIN한다.
- 도시정보는 CITY테이블에
- 대륙 정보는 COUNTRY 테이블에 있음
- 두 테이블을 국가코드(COUNTRYCODE/CODE) 기준으로 연결함

```sql
SELECT COUNTRY.CONTINENT, CITY.POPULATION
FROM CITY
JOIN COUNTRY ON CITY.COUNTRYCODE = COUNTRY.CODE;
```

<img width="154" height="251" alt="image" src="https://github.com/user-attachments/assets/c3a793a0-247b-43ad-8c1e-6b2a08c35f27" />


# 2단계 : GROUP BY 규칙 => 집계 => FLOOR
```sql
SELECT COUNTRY.CONTINENT, FLOOR(AVG(CITY.POPULATION))
FROM CITY
JOIN COUNTRY ON CITY.COUNTRYCODE = COUNTRY.CODE
GROUP BY COUNTRY.CONTINENT;
```

<img width="206" height="160" alt="image" src="https://github.com/user-attachments/assets/fccde68d-b9f4-4944-b55f-71a42a7f0801" />
