#!/usr/bin/python3
# Humam Rashid
# Sample functions in Python, mix of original work and stuff from around the
# internet.

import math
from datetime import date

# 1. Get volume of a sphere given radius r.
def sphere(r):
    return (4/3) * math.pi * (r**3)

# 2. Get real roots of quadratic equation of the form ax^2+bx+c=0.
def quadratic_equation(a,b,c):
    d = math.sqrt(b*b - 4*a*c)
    if d < 0:
        raise ValueError('Negative Discriminant!')
    r1 = (-b+d) / (2*a)
    r2 = (-b-d) / (2*a)
    return (r1, r2)

# 3. Get number of zeroes in a list of numbers.
def number_of_zeroes(lst):
    return sum([1 for e in lst if e == 0])

# 4. Print first n rows of Pascal's triangle.
def next_row(row):
    row1 = [1]
    for i in range(len(row)-1):
        row1.append(row[i]+row[i+1])
    row1.append(1)
    return row1
def draw_pascal(n):
    row = [1]
    rows = [row]
    for i in range(n-1):
        row = next_row(row)
        rows.append(row)
    return rows

# 5. Find unique positive integer N whose square is 1_2_3_4_5_6_7_8_9_0 and each
# '_' is a single digit.
def is_concealed(n):
    digits = str(n)
    template = "1_2_3_4_5_6_7_8_9_0"
    if len(digits) != len(template):
        return False
    return all(digits[i]==template[i] for i in range(0, len(digits), 2))
def euler206():
    print(next((n for n in range(1000000000, 1390000000, 10)
        if (n % 100 == 30 or n % 100 == 70) and is_concealed(n*n))))

# 6. Get number of days between two dates.
def days(date1, date2):
    return (date2-date1).days

# 7. Remove consecutive duplicate elements from a given list.
def remove_consecutive_dups(lst):
    l = []
    prev = None
    for i in lst:
        if i != prev:
            l.append(i)
        prev = i
    return l

# 8. Remove all duplicate elements from a given list.
def remove_dups(lst):
    s = {}
    l = []
    for e in lst:
        if not (e in s):
            s[e] = True
            l.append(e)
    return l

# 9. Replicate each element of a given list n number of times.
def replicate(lst, n):
    l = []
    for i in lst:
        for j in range(n):
            l.append(i)
    return l

# 10. Split a given list into 2 parts with the first part having n elements.
def split(lst, n):
    return (lst[0:n], lst[n:0])

# 11. Get the min, max and median of a given list of numbers.
def min_max_median(lst):
    s = sorted(lst)
    n = len(s)
    return (s[0], s[n-1], 0.5 * (s[(n-1) // 2] + s[n // 2]))

# 12. Get the binomial coefficient.
def bc(n, k):
    if k == 0:
        return 1
    if n == k:
        return 1
    return bc(n-1, k) + bc(n-1, k-1)

# 13. Get the n-element subsets of a given set.
def powerset(s):
    if s == []:
        return [[]]
    [x, *s1] = s
    ps1 = powerset(s1)
    ps2 = [[x] + sub for sub in ps1]
    return ps1 + ps2
def subsets(s, n):
    l = []
    ps = powerset(s)
    for i in ps:
        if len(i) == n:
            l.append(i)
    return l

# 14. get contiguous subarray which has largest sum.
def maximum_subarray(arr):
    return max((arr[begin:end] for begin in range(len(arr)+1)
                               for end in range(begin, len(arr)+1)),
                               key=sum
              )

# EOF.
