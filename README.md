> select qtype, avg(qtime), min(qtime), max(qtime) from query_times group by qtype;
> +-------+-------------+------------+-------------+
> | qtype | avg(qtime)  | min(qtime) | max(qtime)  |
> +-------+-------------+------------+-------------+
> |     0 | 59.45557799 |    14.2694 | 133739.8100 |
> |     1 | 56.37420515 |    13.5088 | 133559.5894 |
> +-------+-------------+------------+-------------+

TYPE:
0 - By primary key (for example: ... WHERE c_primary = 1640804 )
1 - By secondary key (for example: ... WHERE c_secondary = 1512590 )
