use role sysadmin;
use warehouse TEST_WH;
use database FROSTYFRIDAY_DB;
use schema FROSTYFRIDAY_DB.FF;

--使用するテーブルを作成
--0~1000間のランダムな数値を100個作成しInsert
create or replace table ff_week_5 (start_int number);
insert into FF_WEEK_5 (start_int)
select UNIFORM(0,1000,random()) as start_int
from table(GENERATOR(ROWCOUNT => 100));

table FROSTYFRIDAY_DB.FF.FF_WEEK_5;

/**
GENERATE関数：
指定された行数、指定された生成期間（秒単位）、またはその両方に基づいてデータの行を作成します。このシステム定義のテーブル関数により、合成行の生成が可能になる
**/

--pythonで作る
create or replace function timesthree(i int)
returns int
language python
runtime_version = '3.11'
handler = 'timesthree_py'
as
$$
def timesthree_py(i):
  return i*3
$$;

select start_int,timesthree(start_int) as start_int_x3
from FF_WEEK_5
order by start_int;

--SQLで作る
create or replace function timesthree_by_sql(i int)
returns int 
language sql
as
$$
i*3
$$;

select start_int,timesthree_by_sql(start_int) as start_int_x3 
from FF_WEEK_5 
order by start_int;

--Scalaで作る
create or replace function timesthree_scala(i int)
returns int
language scala
handler = 'TimesthreeScala.timesthree'
as
$$
object TimesthreeScala {
  def timesthree(i: Int): Int = {
    i * 3
  }
}
$$;

select start_int, timesthree_scala(start_int) as start_int_x3
from FF_WEEK_5
order by start_int;

--JavaScriptで作る
create or replace function timesthree_js(i int)
returns int
language javascript
as
$$
  return i * 3;
$$;

select start_int, timesthree_js(start_int) as start_int_x3
from FF_WEEK_5
order by start_int;

-- Javaで作る
create or replace function timesthree_java(i int)
returns int
language java
handler = 'TimesthreeJava.timesthree'
as
$$
public class TimesthreeJava {
  public static int timesthree(int i) {
    return i * 3;
  }
}
$$;

select start_int, timesthree_java(start_int) as start_int_x3
from FF_WEEK_5
order by start_int;

