-- MS SQL Server

/*==================================================================================================================================================*/
/* --- --- Процесс / Process --- --- */
/*==================================================================================================================================================*/

	-- Бэкап таблицы / Backup table
	-- Восстановление таблицы из бэкапа / 

/*==================================================================================================================================================*/
/* --- --- Подготовка исходных данных / Preperation of source data --- --- */
/*==================================================================================================================================================*/
	
	/* --- ##table_1 --- */
	
		IF OBJECT_ID('tempdb.dbo.##table_1', 'U') IS NOT null
		DROP TABLE ##table_1;

		CREATE TABLE ##table_1 (
			  id TINYINT IDENTITY(1, 1)
			, t1_field VARCHAR(64));

		INSERT INTO ##table_1 VALUES
			('Some text in ##table_1 in row 1'),
			('Some text in ##table_1 in row 2'),
			('Some text in ##table_1 in row 3'),
			('Some text in ##table_1 in row 4'),
			('Some text in ##table_1 in row 5');
	
	/* --- ##table_2 --- */
	
		IF OBJECT_ID('tempdb.dbo.##table_2', 'U') IS NOT null
		DROP TABLE ##table_2;

		CREATE TABLE ##table_2 (
			  id TINYINT IDENTITY(1, 1)
			, t1_field VARCHAR(64));

		INSERT INTO ##table_2 VALUES
			('Some text in ##table_2 in row 1'),
			('Some text in ##table_2 in row 2'),
			('Some text in ##table_2 in row 3'),
			('Some text in ##table_2 in row 4'),
			('Some text in ##table_2 in row 5');

	/* --- ##table_3 --- */
	
		IF OBJECT_ID('tempdb.dbo.##table_3', 'U') IS NOT null
		DROP TABLE ##table_3;

		CREATE TABLE ##table_3 (
			  id TINYINT IDENTITY(1, 1)
			, t1_field VARCHAR(64));

		INSERT INTO ##table_3 VALUES
			('Some text in ##table_3 in row 1'),
			('Some text in ##table_3 in row 2'),
			('Some text in ##table_3 in row 3'),
			('Some text in ##table_3 in row 4'),
			('Some text in ##table_3 in row 5');

	/* --- Проверка создания и наполнения таблиц исходных данных --- */
		
		SELECT '##table_1', * FROM ##table_1
		UNION ALL
		SELECT '##table_2', * FROM ##table_2
		UNION ALL
		SELECT '##table_3', * FROM ##table_3;

/*==================================================================================================================================================*/
/* --- --- Список таблиц для бэкапа / List of tables to backup --- --- */
/*==================================================================================================================================================*/

	/* --- Создание и наполнение таблицы --- */

		IF OBJECT_ID('tempdb.dbo.##tables_to_un_backup', 'U') IS NOT null
		DROP TABLE ##tables_to_un_backup;

		CREATE TABLE ##tables_to_un_backup (
			  id TINYINT IDENTITY(1, 1)
			, tbl VARCHAR(64));

		INSERT INTO ##tables_to_un_backup VALUES
			('##table_1'),
			('##table_2'),
			('##table_3');

	/* --- Проверка создания и наполнения таблицы --- */
	
		SELECT '##tables_to_un_backup', * FROM ##tables_to_un_backup;

/*==================================================================================================================================================*/
/* --- --- BackUp --- --- */
/*==================================================================================================================================================*/

	/* --- Бэкапирование --- */

		-- Бэкап происходит путём создания идентичной копии бэкапируемой таблицы с добавлением "_backup" в названии итоговой таблицы

		-- Процедура:		
		-- - Берётся текстовый шаблон процедуры бэкапа
		-- - В нужных местах подставляется наименование бэкапируемой таблицы. Текстовый шаблон уже содержит добавление "_backup" в нужных местах.
		-- - Получившийся текст кладётся в переменную "@command_backup"
		-- - С помощью функции "EXECUTE" выполняется текст в переменной "@command_backup"

		/* Переменные для счётчика цикла */
		DECLARE @start_counter_backup AS TINYINT = 1;
		DECLARE @end_counter_backup AS TINYINT = (SELECT COUNT(*) FROM ##tables_to_un_backup);
		DECLARE @counter_backup AS TINYINT = @start_counter_backup;
		
		/* Переменные для процедуры внутри цикла */
		DECLARE @table_to_backup AS VARCHAR(64);
		DECLARE @command_backup AS VARCHAR(512);

		/* Цикл */
		WHILE @counter_backup <= @end_counter_backup
		BEGIN
			SET @table_to_backup = (SELECT tbl FROM ##tables_to_un_backup WHERE id = @counter_backup);
			SET @command_backup = (
				  'IF OBJECT_ID(' + '''' + 'tempdb.dbo.' + @table_to_backup + '_backup' + '''' + ', ' + '''' + 'U' + '''' + ') IS NOT null' + CHAR(13) + CHAR(10)
				+ 'DROP TABLE ' + @table_to_backup + '_backup' + ';' + CHAR(13) + CHAR(10)
				+ CHAR(13) + CHAR(10)
				+ 'SELECT * INTO ' + @table_to_backup + '_backup' + CHAR(13) + CHAR(10)
				+ 'FROM ' + @table_to_backup + ';' + CHAR(13) + CHAR(10)
				+ CHAR(13) + CHAR(10));
			--PRINT(@command_backup);
			EXECUTE(@command_backup);
			SET @counter_backup += 1;
		END;

	/* --- Проверка создания таблиц-бэкапов --- */

		SELECT '##table_1_backup', * FROM ##table_1_backup
		UNION ALL
		SELECT '##table_2_backup', * FROM ##table_2_backup
		UNION ALL
		SELECT '##table_3_backup', * FROM ##table_3_backup;

/*==================================================================================================================================================*/
/* --- --- Внести изменения в таблицы исходных данных / Update tables with source data --- --- */
/*==================================================================================================================================================*/

	/* --- ##table_1 --- */

		INSERT INTO ##table_1 VALUES
			('Some text in ##table_1 in row 6'),
			('Some text in ##table_1 in row 7'),
			('Some text in ##table_1 in row 8'),
			('Some text in ##table_1 in row 9'),
			('Some text in ##table_1 in row 10');
	
	/* --- ##table_2 --- */

		INSERT INTO ##table_2 VALUES
			('Some text in ##table_2 in row 6'),
			('Some text in ##table_2 in row 7'),
			('Some text in ##table_2 in row 8'),
			('Some text in ##table_2 in row 9'),
			('Some text in ##table_2 in row 10');

	/* --- ##table_3 --- */

		INSERT INTO ##table_3 VALUES
			('Some text in ##table_3 in row 6'),
			('Some text in ##table_3 in row 7'),
			('Some text in ##table_3 in row 8'),
			('Some text in ##table_3 in row 9'),
			('Some text in ##table_3 in row 10');

	/* --- Проверка внесения изменений в таблицы исходных данных --- */

		SELECT '##table_1', * FROM ##table_1
		UNION ALL
		SELECT '##table_2', * FROM ##table_2
		UNION ALL
		SELECT '##table_3', * FROM ##table_3;

/*==================================================================================================================================================*/
/* --- --- UnBackUp --- --- */
/*==================================================================================================================================================*/

	/* --- Восстановление из бэкапа --- */

		-- Восстановление из бэкапа происходит путём удаления таблиц с исходными данными и созданием идентичных копий бэкап-таблиц, но без окончания "_backup" в названии итоговой таблицы.

		-- Процедура:
		-- - Берётся текстовый шаблон процедуры восстановления из бэкапа
		-- - В нужных местах подставляется наименование восстанавливаемых таблиц.
		-- - Получившийся текст кладётся в переменную "@command_unbackup"
		-- - С помощью функции "EXECUTE" выполняется текст в переменной "@command_unbackup"

		/* Переменные для счётчика цикла */
		DECLARE @start_counter_unbackup AS TINYINT = 1;
		DECLARE @end_counter_unbackup AS TINYINT = (SELECT COUNT(*) FROM ##tables_to_un_backup);
		DECLARE @counter_unbackup AS TINYINT = @start_counter_unbackup;
		
		/* Переменные для процедуры внутри цикла */
		DECLARE @table_to_unbackup AS VARCHAR(64);
		DECLARE @command_unbackup AS VARCHAR(512);

		/* Цикл */
		WHILE @counter_unbackup <= @end_counter_unbackup
		BEGIN
			SET @table_to_unbackup = (SELECT tbl FROM ##tables_to_un_backup WHERE id = @counter_unbackup);
			SET @command_unbackup = (
				  'IF OBJECT_ID(' + '''' + 'tempdb.dbo.' + @table_to_unbackup + '''' + ', ' + '''' + 'U' + '''' + ') IS NOT null' + CHAR(13) + CHAR(10)
				+ 'DROP TABLE ' + @table_to_unbackup + ';' + CHAR(13) + CHAR(10)
				+ CHAR(13) + CHAR(10)
				+ 'SELECT * INTO ' + @table_to_unbackup + CHAR(13) + CHAR(10)
				+ 'FROM ' + @table_to_unbackup + '_backup' + ';' + CHAR(13) + CHAR(10)
				+ CHAR(13) + CHAR(10));
			--PRINT(@command_unbackup);
			EXECUTE(@command_unbackup);
			SET @counter_unbackup += 1;
		END;

	/* --- Проверка восстановления из бэкапа --- */

		SELECT '##table_1', * FROM ##table_1
		UNION ALL
		SELECT '##table_2', * FROM ##table_2
		UNION ALL
		SELECT '##table_3', * FROM ##table_3;

/*==================================================================================================================================================*/
/* --- --- Удалить временные таблицы / Delete temporary tables --- --- */
/*==================================================================================================================================================*/

	/* --- Удалить таблицы с исходными данными --- */
		
		IF OBJECT_ID('tempdb.dbo.##table_1', 'U') IS NOT null DROP TABLE ##table_1;
		IF OBJECT_ID('tempdb.dbo.##table_2', 'U') IS NOT null DROP TABLE ##table_2;
		IF OBJECT_ID('tempdb.dbo.##table_3', 'U') IS NOT null DROP TABLE ##table_3;
	
	/* --- Удалить бэкап-таблицы --- */

		IF OBJECT_ID('tempdb.dbo.##table_1_backup', 'U') IS NOT null DROP TABLE ##table_1_backup;
		IF OBJECT_ID('tempdb.dbo.##table_2_backup', 'U') IS NOT null DROP TABLE ##table_2_backup;
		IF OBJECT_ID('tempdb.dbo.##table_3_backup', 'U') IS NOT null DROP TABLE ##table_3_backup;

	/* --- Удалить таблицы списков таблиц --- */
		
		IF OBJECT_ID('tempdb.dbo.##tables_to_un_backup', 'U') IS NOT null DROP TABLE ##tables_to_un_backup;