https://www.hackerrank.com/challenges/binary-search-tree-1/problem?isFullScreen=true

# 1단계 : 접근 방식 고민 : CASE WHEN 문
- CASE WHEN 문을 쓰는건 알겠는데
- EXISTS를 고민하지 못했음.

```
EXISTS는 “이 조건을 만족하는 행이 하나라도 있냐?”를 묻는 연산자

EXISTS (서브쿼리) 형태로 쓴다.

```

- 결과는 TRUE / FALSE
- 값 자체에는 관심 없음
- 존재 여부만 본다

1. CASE WHEN 으로 조건 걸기. => P가 NULL 이면 ROOT노드 이다.
2. 부모 노드와 자식 노드가 둘 다 존재하면 INNER 노드이다
3. 그 외에는 LEAF 노드이다





# 추가 공부
# EXISTS는 언제 쓰냐? (3가지 대표 패턴)
- ① 자기 자신과 비교 (Self-reference)

👉 이번 BST 문제

```sql
EXISTS (
  SELECT 1
  FROM BST b2
  WHERE b2.P = b1.N
)
```
```
의미:
“이 노드를 부모로 갖는 행이 있나?”
📌 같은 테이블을 두 역할로 나눔
b1 = 현재 행
b2 = 비교 대상
```



- ② 다른 테이블과의 관계 확인 (가장 흔함)

```sql
SELECT *
FROM users u
WHERE EXISTS (
  SELECT 1
  FROM orders o
  WHERE o.user_id = u.id
);
```
```
의미:
“주문을 한 번이라도 한 유저만 가져와라”
📌 여기서는
두 테이블(users ↔ orders) 관계 확인 ⭕️
```


- ③ 조건 충족 여부만 확인 (값은 관심 없음)

```sql
SELECT *
FROM products p
WHERE EXISTS (
  SELECT 1
  FROM reviews r
  WHERE r.product_id = p.id
    AND r.rating >= 4
);
```
```
의미:
“별점 4 이상 리뷰가 하나라도 있는 상품”
```
