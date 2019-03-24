with tb_json as (
    select 'a'::character varying(255) as client, 1::integer as code, 'x'::character varying(255) as name union all
    select 'a'::character varying(255) as client, 2::integer as code, 'y'::character varying(255) as name union all
    select 'b'::character varying(255) as client, 3::integer as code, 'z'::character varying(255) as name union all
    select 'b'::character varying(255) as client, 4::integer as code, 'w'::character varying(255) as name union all
    select 'b'::character varying(255) as client, 5::integer as code, 'v'::character varying(255) as name union all
    select 'b'::character varying(255) as client, 6::integer as code, 'u'::character varying(255) as name
)
select client
     , jsonb_agg(row_to_json((SELECT col_json FROM (SELECT code, name) as col_json))) as details
  from tb_json
GROUP  BY client;