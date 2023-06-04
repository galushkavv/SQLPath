use Graphs;

-- Àëãîðèòì Äåéêñòðû --

declare @from int
set @from = 1 -- îòêóäà
declare @to int
set @to = 7 -- êóäà

create table #vertexes
(
	number int,
	status int,
	distance float,
	prev int
)

create table #tmp
(
	number int,
	status int,
	distance float,
	prev int
)

insert into #vertexes (number, status, distance)
	select distinct v1, case(v1) when @from then 2 else 0 end, case(v1) when @from then 0 else 9999999999/*áåñêîíå÷íîñòü*/ end
	from Edges

while((select count(*) from #vertexes where status = 0) > 0)
begin
	delete from #tmp

	insert into #tmp
	select v2, 0, distance+weight, v1
	from #vertexes inner join Edges on Edges.v1=#vertexes.number
	where status = 2
	
	delete from #tmp where number not in (select #tmp.number from #tmp inner join #vertexes on #tmp.number=#vertexes.number and #vertexes.distance > #tmp.distance)
	delete from #vertexes where number in (select number from #tmp)

	insert into #vertexes(number, status, distance, prev)
	select * from #tmp

	update #vertexes set status = 1 where status = 2
	update #vertexes set status = 2 where number =
	(
		select top(1) number from #vertexes where distance = (select min(distance) from #vertexes where status = 0) and status = 0
	)
end

select number, prev, distance from #vertexes
order by distance

create table #path
(
	vertex int
)
insert into #path values (@to)
while(@to is not null)
begin
	insert into #path
	select prev from #vertexes where number=@to
	select @to=prev from #vertexes where number=@to
end
select * from #path where vertex is not null

drop table #path
drop table #tmp
drop table #vertexes
