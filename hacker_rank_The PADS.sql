/* 

1) OCCUPATIONS 테이블에서
   모든 Name을 알파벳순으로 출력한다.
   각 Name 뒤에 직업(Occupation)의 첫 글자를 괄호로 붙인다.
   예: AnActorName(A), ADoctorName(D) ...

2) OCCUPATIONS 테이블에서
   직업별 인원 수를 구한다.
   인원 수 오름차순 정렬,
   인원 수가 같다면 직업명을 알파벳순 정렬한다.
   출력 형식:
   There are a total of [occupation_count] [occupation]s.
   (occupation은 소문자)

*/


SELECT RESULT
FROM(
    /* =========================
       [첫 번째 블록] 이름 목록
       =========================
       RESULT : Name + '(' + 직업 첫 글자 + ')'
       GRP    : 이 블록이 첫 번째로 출력되도록 1을 부여
       n      : 이름 정렬용 컬럼
       c, o   : 이 블록에서는 필요 없으므로 NULL
    */
    SELECT 
        CONCAT(Name, '(', LEFT(Occupation,1), ')')AS RESULT, 1 as GRP, Name AS n, NULL AS c, NULL as o
    FROM OCCUPATIONS
    -- ORDER BY Name

    UNION ALL
    /* =========================
       [두 번째 블록] 직업별 인원 수
       =========================
       RESULT : "There are a total of X occupations."
       GRP    : 이 블록이 두 번째로 출력되도록 2를 부여
       n      : 이름 정렬 불필요 → NULL
       c      : COUNT(*) 값을 저장 → 인원 수 오름차순 정렬용
       o      : Occupation → 인원 수가 같을 때 알파벳 정렬용
    */
    SELECT
        CONCAT(
            'There are a total of ',
            COUNT(*),
            ' ',
            LOWER(Occupation),
            's.'
        )AS RESULT, 2 AS GRP, NULL as n, COUNT(*) AS c, NULL as o
    FROM OCCUPATIONS
    GROUP BY Occupation
    -- ORDER BY COUNT(*), Occupation
) as sub_table
ORDER BY GRP, n, c, o;
