https://www.hackerrank.com/challenges/full-score/problem?isFullScreen=true
level : medium    


문제 : 
Julia가 코딩 대회를 끝냈다.   
이제 두 개 이상의 문제에서 만점을 받은 해커들의 리더보드를 만들고 싶다.    

1. hacker_id
2. name


# 1단계 : Challenges와 Difficulty 테이블을 join해서 각 문제의 최대 점수를 확인한다.

```sql
SELECT c.hacker_id, c.challenge_id, c.difficulty_level, d.score
FROM Challenges c
JOIN Difficulty d ON c.difficulty_level = d.difficulty_level
```

<img width="167" height="243" alt="image" src="https://github.com/user-attachments/assets/408441c6-84f9-42e5-bcc6-d67cbaa59810" />


# 2단계 : 이걸 서브쿼리로 해서 alias를 하고 SUBMISSION과 JOIN

```sql
SELECT s.hacker_id, full_score.challenge_id, full_score.difficulty_level, s.score
FROM Submissions s
JOIN(
    SELECT c.challenge_id, c.difficulty_level, d.score
    FROM Challenges c
    JOIN Difficulty d ON c.difficulty_level = d.difficulty_level
    ) AS full_score
ON s.challenge_id = full_score.challenge_id
```

<img width="270" height="243" alt="image" src="https://github.com/user-attachments/assets/77c510b3-fb37-43df-b315-1bfc861a9a30" />


# 3단계 : 만점 제출만 필터링
- 만점인 친구 : 문제의 최대 점수 = 해커 점수(full_score.score_needed = s.score)

```sql
SELECT *
FROM Submissions s
JOIN(
    SELECT c.challenge_id, c.difficulty_level, d.score AS score_needed
    FROM Challenges c
    JOIN Difficulty d ON c.difficulty_level = d.difficulty_level
    ) AS full_score
ON s.challenge_id = full_score.challenge_id
WHERE full_score.score_needed = s.score;
```
<img width="270" height="243" alt="image" src="https://github.com/user-attachments/assets/2bd0e72e-edf9-4e40-91d1-867a45902233" />

# 4단계 : 2개 이상의 문제에서 만점을 받은 해커를 찾아라!
### 4.1.해커 아이디로 GROUP BY를 하자

```sql
SELECT s.hacker_id, COUNT(s.challenge_id)
FROM Submissions s
JOIN(
    SELECT c.challenge_id, c.difficulty_level, d.score AS score_needed
    FROM Challenges c
    JOIN Difficulty d ON c.difficulty_level = d.difficulty_level
    ) AS full_score
ON s.challenge_id = full_score.challenge_id
WHERE full_score.score_needed = s.score
GROUP BY s.hacker_id;
```
<img width="270" height="243" alt="image" src="https://github.com/user-attachments/assets/9f36da81-5e23-4036-aaee-355b4e1ecff0" />

### 4.2. DISTICT 사용하기 => 한명의 해커가 하나의 문제에서 두번 이상 만점을 받을 수 있음

```sql
SELECT s.hacker_id
FROM Submissions s
JOIN(
    SELECT c.challenge_id, c.difficulty_level, d.score AS score_needed
    FROM Challenges c
    JOIN Difficulty d ON c.difficulty_level = d.difficulty_level
    ) AS full_score
ON s.challenge_id = full_score.challenge_id
WHERE full_score.score_needed = s.score
GROUP BY s.hacker_id
HAVING COUNT(DISTINCT(s.challenge_id)) >= 2;
```

# 5. 해커 이름은 Hackers 테이블에 있기 때문에 JOIN을 한다
- JOIN
- ORDER BY

```sql
SELECT h.hacker_id, h.name
FROM Hackers h
JOIN (
    SELECT s.hacker_id, COUNT(DISTINCT s.challenge_id) AS full_cnt      -- COUNT(DISTINCT s.challenge_id) AS full_cnt  이걸 빼먹으면 안됨 order by 하기 위해 이름도 지어준다
FROM Submissions s
JOIN(
    SELECT c.challenge_id, c.difficulty_level, d.score AS score_needed
    FROM Challenges c
    JOIN Difficulty d ON c.difficulty_level = d.difficulty_level
    ) AS full_score
ON s.challenge_id = full_score.challenge_id
WHERE full_score.score_needed = s.score
GROUP BY s.hacker_id
HAVING COUNT(DISTINCT(s.challenge_id)) >= 2 
) AS cnt
ON h.hacker_id = cnt.hacker_id
ORDER BY
  cnt.full_cnt DESC,
  h.hacker_id ASC;

```

<img width="610" height="441" alt="image" src="https://github.com/user-attachments/assets/9dd42952-9aa8-43d0-9471-bbac12d088ea" />

# 회고 
서브쿼리 지옥이 됐다. 가독성도 성능도 너무 좋지 않다.
좋지 않은 쿼리인 것 같아서 다른 방식으로 풀 수 있는지 gpt한테 물어봐야겠음.......

좋은 쿼리는 join을 그냥 4번 하는거라고 한다.


```sql
SELECT
  s.hacker_id,
  h.name
FROM Submissions s
JOIN Challenges c
  ON s.challenge_id = c.challenge_id
JOIN Difficulty d
  ON c.difficulty_level = d.difficulty_level
JOIN Hackers h
  ON s.hacker_id = h.hacker_id
WHERE s.score = d.score
GROUP BY s.hacker_id, h.name
HAVING COUNT(DISTINCT s.challenge_id) >= 2
ORDER BY
  COUNT(DISTINCT s.challenge_id) DESC,
  s.hacker_id ASC;
```

이 문제의 포인트는
1. JOIN 차례대로 여러번
2. DISTICT

로 생각하기로 함
