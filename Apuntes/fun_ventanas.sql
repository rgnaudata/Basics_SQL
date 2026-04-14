/*
-- FUNCIONES DE VENTANA

select category, qty, orderyear, 
	SUM (Qty) OVER (
    PARTITION BY category
    ORDER BY orderyear
    ROWS BETWEEN UBOUNDED PRECEDING 
    AND CURRENT ROW) AS RunningQty
FROM SALES.CategoryQtyYear;


OVER ([ <PARTITION BY clause> ]
	[ <ORDER BY clause> ]
    [ <ROWS or RANGE clause> ]
    )
    
-- ejemplo 1
select country, companyname,
row_number() over (order by companyname)
from customers 
	--> devuelve columnas country, companyname y otra con la numeracion de los registros

-- ejemplo 2
select country, companyname,
row_number() over (partition by country order by companyname)
from customers 
	--> devuelve columnas country, companyname y otra con la numeracion por pais
    (cuenta el num registros aparece cada pais y donde la numeracion empieza de nuevo en cada pais)
    
-- ejemplo 3
select CustomerID, Orderid, Val, 
sum(Val) over (Partition by CustomerID
				order by OrderId, OrderId, ROWS BETWEEN UNBOUNDED PRECEDING 
                AND CURRENT ROW) as TotalCustomers)
from view_totalorder
	--> devuelve columnas customerId, OrderID, Val (valor) i una columna TotalCustomers donde se va sumando los valores anteriores de cada cliente. 
    
-- ejemplo 4
select c.categoriname, p.productname, p.unitprice,
rank() over (partition by c.categoriname order by p.unitprice desc) as [rank]
from categories as c inner join products as p
on c.categoriID = p.CategoriID 
Go
	--> devuelve una columna al final con elranking de los precios mas caros a los mas baratos por categorias 
		(numera o hace el ranking de cada categoria por separado)