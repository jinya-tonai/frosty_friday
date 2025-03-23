--ウェアハウスの使用権原をSYSADMINに渡す
use role accountadmin;
grant usage on warehouse compute_wh to role sysadmin;

--データベース作成
use role sysadmin;
create or replace database db_week1;

--スキーマ作成
create or replace schema schema_week1;

--s3のデータを参照して外部ステージを作成
create or replace stage stage_week1
url = 's3://frostyfridaychallenges/challenge_1/';

--s3内のデータを確認
list @stage_week1;

--ステージは*を使えない。＄で持ってくる。
select $1,$2,$3 from @stage_week1;

--snowflake固有のメタデータを用いてステージ上のデータを見る
select $1, metadata$filename,metadata$file_row_number
from @stage_week1
order by metadata$filename,metadata$file_row_number;

--テーブル作成
create or replace table table_week1(
    result varchar,
    filename varchar,
    file_row_number int
);

--データロード
copy into table_week1 from (
select 
    $1, 
    metadata$filename,
    metadata$file_row_number
from @stage_week1
);

--答えの文を見る
select * from table_week1
where file_row_number !=1
order by filename,file_row_number
;
