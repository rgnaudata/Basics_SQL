/*
Declaraciones INSERT para agregar una o múltiples filas de datos
Consultas SELECT para recuperar y dar formato a los datos
Declaraciones UPDATE para modificar datos existentes.¡Siempre use una cláusula WHERE con las declaraciones UPDATE! Sin WHERE, la actualización afectará a TODAS las filas de la tabla.
	UPDATE products
	SET price = 54.99
	WHERE name = 'Coffee Maker';
Declaraciones DELETE para eliminar datos de las tablas. es fundamental utilizar WHERE con DELETE para evitar eliminar accidentalmente todos los datos.
*/

CREATE database if NOT EXISTS company;
USE company;
CREATE TABLE IF NOT EXISTS employees(
	employee_id INT PRIMARY KEY,
	employee_name VARCHAR(50),
	department VARCHAR(50),
	salary DECIMAL(10,2)
);
INSERT INTO employees (employee_id, employee_name, department, salary) VALUES
(1, 'ALice', 'Sales', 60000.00),
(2, 'Bob', 'Marketing', 55000.00),
(3, 'Charlie', 'Sales', 65000.00),
(4, 'David', 'IT', 70000.00),
(5, 'Eve', 'Marketing', 62000.00)
ON DUPLICATE KEY UPDATE -- Si ja existeix id=1 → actualitza el valor en lloc de donar error
	employee_name = VALUES (employee_name),
	department = VALUES (department),
	salary = VALUES (salary);

SELECT * FROM employees; -- comprovem que s'ha creat la taula

/* Clasificar Filas con ROW_NUMBER()
La función ROW_NUMBER() asigna un entero secuencial único a cada fila dentro de una partición de un conjunto de resultados. 
Se utiliza comúnmente para clasificar y paginar.

La sintaxis básica es:
ROW_NUMBER() OVER (ORDER BY column_name [ASC|DESC])

OVER(): Esta cláusula define la ventana (el conjunto de filas) para la función.
ORDER BY: Esta cláusula, dentro de OVER(), especifica el orden en que se asignan los números de fila.
usamos ROW_NUMBER() para clasificar a los empleados por su salario en orden descendente.
*/

SELECT
	employee_name,
	department, 
	salary,
	ROW_NUMBER() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

/* Calcular un Total Acumulado con SUM()
Un total acumulado, o suma acumulativa, es la suma de una secuencia de números que se actualiza a medida que se agrega cada nuevo número. 
En SQL, puede calcular esto usando SUM() OVER().

La sintaxis es:
SUM(column_name) OVER (ORDER BY column_name [ASC|DESC])

Esta función suma los valores de una columna en el orden especificado por la cláusula ORDER BY.

Ahora, calculemos el total acumulado de salarios, ordenados por employee_id.
*/

SELECT 
	employee_name,
	salary, 
	SUM(salary) OVER (ORDER BY employee_id) AS running_total
FROM employees;


/* Agrupar Cálculos con PARTITION BY
La cláusula PARTITION BY divide el conjunto de resultados en particiones (grupos) y aplica la función de ventana a cada partición de forma independiente. Esto es útil para realizar cálculos dentro de categorías específicas.

La sintaxis es:
function() OVER (PARTITION BY column_name ORDER BY ...)

Usemos PARTITION BY para clasificar a los empleados dentro de cada departamento según su salario.
*/

SELECT 
employee_name, 
department, 
salary,
ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_in_dept
FROM employees;

/* Comparar Filas con LAG()
La función LAG() proporciona acceso a una fila en un desplazamiento físico especificado que precede a la fila actual. 
Es útil para comparar un valor en la fila actual con un valor en una fila anterior.

La sintaxis es:
LAG(expression, offset, default_value) OVER (ORDER BY ...)

expression: La columna o expresión a recuperar.
offset: El número de filas a retroceder (el valor predeterminado es 1).
default_value: El valor a devolver si el desplazamiento está fuera de los límites (por ejemplo, para la primera fila).
Encontremos el salario del empleado anterior en la lista, ordenado por employee_id.
*/

-- Esta consulta recupera el salario de la fila anterior. Para la primera fila, donde no hay fila anterior, devuelve NULL.
SELECT 
employee_name,
salary, 
LAG (salary) OVER(ORDER BY employee_id) AS previous_salary
FROM employees;

/*
Puede usar esto para calcular la diferencia entre salarios consecutivos. 
Cuando el salario anterior es NULL (para la primera fila), el resultado también será NULL.
*/

SELECT 
employee_name, 
salary, 
salary - LAG(salary) OVER (ORDER BY employee_id) AS salary_diff
FROM employees;
-- Esta consulta calcula la diferencia entre el salario del empleado actual y el anterior.

