아 왤케 어려워. 여러번 풀어보기로 한다.
https://www.hackerrank.com/challenges/occupations/problem?isFullScreen=true

## 문제
OCCUPATIONS 테이블에서 Occupation 컬럼을 피벗(Pivot) 하여,
각 직업별(Name)을 알파벳순으로 정렬해 해당 직업 컬럼 아래에 출력하라.

출력은 반드시 다음 4개 컬럼 순서로 구성되어야 한다.

Doctor, Professor, Singer, Actor

컬럼 아래에는 해당 직업에 속한 사람들의 이름을 알파벳순으로 나열한다.

만약 어떤 직업 컬럼에 더 이상 출력할 이름이 없다면
그 자리는 NULL을 출력한다.

---

# 1단계 : 특정 직업에 속하는 사람들을 나열한다. : ROW_NUMBER와 PARTITION BY 사용
1. 직업별로 묶어서 일열로 세우고
2. ROW_NUMBER()로 순위를 부여한다.


```sql
SELECT 
    Name,
    Occupation,
    ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name)
FROM OCCUPATIONS;
```
<img width="272" height="267" alt="image" src="https://github.com/user-attachments/assets/bd127a31-a331-42b8-b5c8-77ac4f1b56be" />


# 2단계 : 서브쿼리로 만든후 재정렬하기
### 2-1. 서브쿼리로 만든다 (ALIAS 부여)
1. rn :ROW_NUMBER로 부여한 순서
2. t : SELECT한 테이블 전체

### 2-2. ORDER BY 절을 사용해서 재정렬한다.
1.ACTOR
2.DOCTOR
3.PROFESSOR
4.SINGER

순으로 정렬 됨

```sql
SELECT rn, Name, Occupation
FROM(
    SELECT 
        Name,
        Occupation,
        ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) as rn
    FROM OCCUPATIONS    
)as t
ORDER BY rn, Occupation;    
```
<img width="272" height="267" alt="image" src="https://github.com/user-attachments/assets/a2b23557-8633-476a-89ac-bf75e1feea9a" />


# 3. CASE 문을 사용해서 나열한다.
이 행이 특정 직업이면 해당 컬럼에 이름을 찍고 아니면 NULL을 넣는다
- 이 작업을 수행하면서 세로였던 테이블이 가로 형태로 pivot됨

```sql
SELECT
    rn,
    CASE WHEN Occupation='Doctor' THEN NAME END,      -- => Jenny NULL NULL NULL
    CASE WHEN Occupation='Professor' THEN NAME END,      -- => NULL Ashley NULL NULL
    CASE WHEN Occupation='Singer' THEN NAME END,      -- => NULL NULL Meera NULL
    CASE WHEN Occupation='Actor' THEN NAME END      -- => NULL NULL NULL Jane
FROM (
    SELECT
        Name,
        Occupation,
        ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
    FROM OCCUPATIONS
) t
ORDER BY rn, Occupation;
```

<img width="272" height="235" alt="image" src="https://github.com/user-attachments/assets/8f976b66-7f41-4f34-831e-8974329ae865" />



# 4단계 : rn기준으로 GROUP BY 후 CASE문에 MAX를 붙여 NULL이 아닌 값만 남긴다

```sql
SELECT
  MAX(CASE WHEN Occupation = 'Doctor'    THEN Name END) AS Doctor,
  MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
  MAX(CASE WHEN Occupation = 'Singer'    THEN Name END) AS Singer,
  MAX(CASE WHEN Occupation = 'Actor'     THEN Name END) AS Actor
FROM (
  SELECT
    Name,
    Occupation,
    ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
  FROM OCCUPATIONS
) t
GROUP BY rn
ORDER BY rn;
```

<img width="272" height="178" alt="image" src="https://github.com/user-attachments/assets/692844d6-30ba-4755-a445-97c006a05580" />


### 왜 이렇게 할까? (pivot시 MAX ~ GROUP BY를 하는 이유)

-- CASE WHEN Occupation='Doctor' THEN Name END을 rn=1 그룹에 적용하면 값이:     

-- (Jenny NULL NULL NULL)

-- 즉 rn=1 그룹 안에서 Doctor 컬럼 후보가 여러 행에 걸쳐 존재하고,
-- 그 중 NULL 아닌 값은 하나(Jenny) 뿐임.

-- 하지만 SQL은 GROUP BY로 묶인 그룹마다 각 컬럼이 “딱 하나의 값”만 가지고 있어야하므로, NULL이 아닌 대표값을 뽑게 하기 위해 MAX() 사용


# 회고
지인이 서브쿼리문을 쓸 때 WITH 문을 쓰면 편하다고 해서
추가적으로 공부를 해봤다!

###WITH 문이란?
서브 쿼리가 반복되면 쿼리 가독성이 떨어지니까
WITH문으로 가상의 테이블을 저장해두고 꺼내 쓰자!

```sql
WITH 가상의 테이블 이름 AS (
  SELECT ...
)

-- 위에서 WITH로 가상의 테이블을 설정해놨기에 아래서 편하게 꺼내쓸 수 있음

SELECT ...
FROM 가상의 테이블 이름;
```

```sql
WITH t AS(
     SELECT
    Name,
    Occupation,
    ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
  FROM OCCUPATIONS    
)

SELECT
  MAX(CASE WHEN Occupation = 'Doctor'    THEN Name END) AS Doctor,
  MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
  MAX(CASE WHEN Occupation = 'Singer'    THEN Name END) AS Singer,
  MAX(CASE WHEN Occupation = 'Actor'     THEN Name END) AS Actor
FROM t
GROUP BY rn
ORDER BY rn;
```

