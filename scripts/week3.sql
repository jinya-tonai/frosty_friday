--権限割当
use role accountadmin;
grant usage on warehouse compute_WH to role sysadmin;

--ロール・ウェアハウス変更
use role sysadmin;
use warehouse compute_wh;

--データベース作成
create or replace database db_week3;

--スキーマ作成　
create or replace schema schema_week3;

--S3データの参照ステージを作成
create or replace stage stage_week3
url = 's3://frostyfridaychallenges/challenge_3/';
list @stage_week3;

--keywords.csvの内容を確認
select $1,$2,$3,$4 
from @stage_week3(pattern => '.*keywords\.csv');

--回答例のファイルを１つ確認
select metadata$filename,metadata$file_row_number,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10
from @stage_week3(pattern => '.*week3_data2_stacy_forget_to_upload\.csv');

--ファイルフォーマットを定義
create file format file_format_week3
type = 'CSV' 
field_delimiter = ',' 
skip_header = 1; 

--テーブル作成
//keywordテーブル
create table table_keyword_week3 (
keyword varchar,
added_by varchar,
nonsense varchar);

//searchテーブル
create or replace table table_search_week3 (
filename varchar,
file_row_number int,
id varchar,
first_name varchar,
last_name varchar, 
catch_phrase varchar,
timestamp date);

--keywordテーブルにs3からデータロード
copy into table_keyword_week3 
from (
    select $1,$2,$3 
    from @stage_week3)
pattern = '.*keywords\.csv'
file_format = 'file_format_week3';

select * 
from table_keyword_week3;

--searchテーブルにs3からデータロード
copy into table_search_week3
from (
    select metadata$filename,metadata$file_row_number,$1,$2,$3,$4,$5,$6,$7,$8,$9,$10
    from @stage_week3)
file_format = 'file_format_week3';

--keywordがファイル名に含まれているデータをsearchテーブルから検索
select * 
from table_search_week3
where exists(
  select keyword
  from table_keyword_week3
  where contains(table_search_week3.filename, table_keyword_week3.keyword));

--何行入っているか集計
select filename, count(*) 
from table_search_week3
where exists (
  select keyword
  from table_keyword_week3
  where contains(table_search_week3.filename, table_keyword_week3.keyword))
group by filename;
