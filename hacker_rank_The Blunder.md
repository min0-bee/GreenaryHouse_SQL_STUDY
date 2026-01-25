https://www.hackerrank.com/challenges/the-blunder/problem?isFullScreen=true
level : 

문제 : 
Samantha는 EMPLOYEES 테이블에 있는 모든 직원들의 평균 월급을 계산하는 일을 맡았다.   
하지만 계산을 모두 끝낸 뒤에야 키보드의 ‘0’(숫자 영) 키가 고장 나 있었다는 사실을 깨달았다.   
즉, 그녀는 월급에서 숫자 0이 모두 제거된 값으로 평균을 잘못 계산해버렸다.   
이제 그녀는 잘못 계산한 평균 월급과 실제 평균 월급
사이의 차이(error) 를 구하고 싶다.

잘못된 평균(0 제거) − 실제 평균 값을 계산하고,
그 결과를 올림하여 다음 정수로 반올림하라.

# 1단계 : 월급에서 모든 0을 제거

```sql
SELECT REPLACE(Salary, '0', '')
FROM EMPLOYEES
```

<img width="168" height="271" alt="image" src="https://github.com/user-attachments/assets/d2a88d79-3c68-42e8-bba9-9d59fe50da9e" />


# 2단계 : 잘못 계산된 평균 - 실제 평균

```sql
SELECT AVG(REPLACE(Salary, '0', '')) - AVG(Salary)
FROM EMPLOYEES
```

# 3단계 : 올림(CEIL)
```sql
SELECT CEIL(
    AVG(Salary) - AVG(REPLACE(Salary, '0', ''))
) AS error
FROM EMPLOYEES;
```

## 💡 REPLACE 함수 주의점

REPLACE()는 문자열 함수이므로 결과를 문자열로 반환한다.
```sql
SELECT REPLACE(10500, '0', '');
```
```sql
'15' (문자열)
```

하지만 MySQL에서는 AVG() 사용 시 문자열을 자동으로 숫자로 형변환하므로     
AVG(REPLACE(...)) 형태가 문제없이 동작한다.    
