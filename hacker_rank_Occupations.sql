-- 아 왤케 어려워
-- https://www.hackerrank.com/challenges/occupations/problem?isFullScreen=true

-- OCCUPATIONS 테이블에서 Occupation 컬럼을 피벗(Pivot) 하여,
-- 각 직업별(Name)을 알파벳순으로 정렬해 해당 직업 컬럼 아래에 출력하라.

-- 출력은 반드시 다음 4개 컬럼 순서로 구성되어야 한다.

-- Doctor, Professor, Singer, Actor


-- 각 컬럼 아래에는 해당 직업에 속한 사람들의 이름을 알파벳순으로 나열한다.

-- 만약 어떤 직업 컬럼에 더 이상 출력할 이름이 없다면
-- 그 자리는 NULL을 출력한다.


-- SELECT 
--     Name,
--     Occupation,
--     ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name)
-- FROM OCCUPATIONS;

-- Jenny      Doctor     1
-- Samantha  Doctor     2

-- Ashley    Professor  1
-- Christeen Professor  2
-- Ketty     Professor  3

-- Meera     Singer     1
-- Priya     Singer     2

-- Jane      Actor      1
-- Julia     Actor      2
-- Maria     Actor      3



-- SELECT rn, Name, Occupation
-- FROM (
--     SELECT
--         Name,
--         Occupation,
--         ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
--     FROM OCCUPATIONS
-- ) t
-- ORDER BY rn, Occupation;


-- rn  Name        Occupation
-- 1   Jenny      Doctor
-- 1   Ashley     Professor
-- 1   Meera      Singer
-- 1   Jane       Actor

-- 2   Samantha  Doctor
-- 2   Christeen Professor
-- 2   Priya     Singer
-- 2   Julia     Actor

-- 3   Ketty     Professor
-- 3   Maria     Actor

-- SELECT
--     CASE WHEN Occupation='Doctor' THEN NAME END,      -- => Jenny NULL NULL NULL
--     CASE WHEN Occupation='Professor' THEN NAME END,      -- => NULL Ashley NULL NULL
--     CASE WHEN Occupation='Singer' THEN NAME END,      -- => NULL NULL Meera NULL
--     CASE WHEN Occupation='Actor' THEN NAME END,      -- => NULL NULL NULL Jane
-- FROM (
--     SELECT
--         Name,
--         Occupation,
--         ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
--     FROM OCCUPATIONS
-- ) t
-- ORDER BY rn, Occupation;


-- SELECT
--     rn,
--     CASE WHEN Occupation = 'Doctor'   THEN Name END AS Doctor,
--     CASE WHEN Occupation = 'Professor' THEN Name END AS Professor,
--     CASE WHEN Occupation = 'Singer'   THEN Name END AS Singer,
--     CASE WHEN Occupation = 'Actor'    THEN Name END AS Actor
-- FROM (
--     SELECT
--         Name,
--         Occupation,
--         ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
--     FROM OCCUPATIONS
-- ) t
-- ORDER BY rn, Occupation;

-- rn Doctor   Professor   Singer   Actor
-- 1  Jenny    NULL        NULL     NULL
-- 1  NULL     Ashley      NULL     NULL
-- 1  NULL     NULL        Meera    NULL
-- 1  NULL     NULL        NULL     Jane

-- 2  Samantha NULL        NULL     NULL
-- 2  NULL     Christeen   NULL     NULL
-- 2  NULL     NULL        Priya    NULL
-- 2  NULL     NULL        NULL     Julia

-- 3  NULL     Ketty       NULL     NULL
-- 3  NULL     NULL        NULL     Maria


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


-- 왜 pivot에 max 값을 쓰고 마지막에 group by를 하는지 고민해보기
-- CASE WHEN Occupation='Doctor' THEN Name END을 rn=1 그룹에 적용하면 값이:

-- (Jenny NULL NULL NULL)

-- 즉 rn=1 그룹 안에서 Doctor 컬럼 후보가 여러 행에 걸쳐 존재하고,
-- 그 중 NULL 아닌 값은 하나(Jenny) 뿐임.

-- 하지만 SQL은 GROUP BY로 묶인 그룹마다 각 컬럼이 “딱 하나의 값”만 가지고 있어야하므로, NULL이 아닌 대표값을 뽑게 하기 위해 MAX() 사용


