use Graphs;

-- Алгорит Флойда-Уоршалла --

declare @from int
declare @to int
set @from=2
set @to=7

create table #vertexes
(
	v1 int,
	v2 int,
	prev int,
	distance float
)

create table #tmp
(
	v1 int,
	v2 int,
	prev int,
	distance float
)

-- вставка в промежуточную таблицу всех рёбер графа (каждое ребро - это путь из одной вершины в соседнюю)
insert into #vertexes (v1, v2, distance)
	select distinct v1, v2, weight from Edges

declare @path_count int
set @path_count=0

while(@path_count<(select count(*) from #vertexes)) -- проверка, добавился ли
begin												-- новый путь в таблицу
	select @path_count=count(*) from #vertexes		-- если нет, то значит все пути найдены
	
	insert into #vertexes
	select w2.v1, w1.v2, w1.v1 as prev, case when w3.distance is null or w1.distance+w2.distance<w3.distance then w1.distance+w2.distance else w3.distance end as dist
	from (#vertexes w1 inner join #vertexes w2 on w1.v1=w2.v2) left join #vertexes w3 on w3.v1=w2.v1 and w3.v2=w1.v2
	where (w3.distance is null or w1.distance+w2.distance<w3.distance) and w2.v1 <> w1.v2
	order by v1, v2

	delete from #tmp
	insert into #tmp
	select distinct w.* from #vertexes w inner join Edges e on w.v1 = e.v2 and (w.prev = e.v1 or w.prev is null) order by distance


	delete from #vertexes
	insert into #vertexes
	select t1.v1, t1.v2, t2.prev, t1.distance from (
		select v1,v2, min(distance) as distance
		from #tmp
		group by v1,v2
	) as t1 inner join #tmp as t2 on  t1.v1=t2.v1 and t1.v2=t2.v2 and t1.distance=t2.distance 


end

create table #path
(
	vertex int
)

select * from #vertexes
insert into #path values (@from)
while (@from is not null)
begin
insert into #path
select case when prev is null then @to else prev end from #vertexes where v1=@from and v2=@to
select @from=prev from #vertexes where v1=@from and v2=@to
end
select * from #path

drop table #path
drop table #tmp
drop table #vertexes