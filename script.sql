-- 1.1 Escreva um cursor que exiba as variáveis rank e youtuber de toda tupla que tiver
-- video_count pelo menos igual a 1000 e cuja category seja igual a Sports ou Music.
DO $$ 
	DECLARE
		cursor_rank_youtuber REFCURSOR;
		video_count INT := 1000;
		category_sport VARCHAR(200) := 'Sport';
		category_music VARCHAR(200) := 'Music';
		v_tabela VARCHAR(200) := 'tp_youtubers';
		tupla RECORD;
	BEGIN
	OPEN cursor_rank_youtuber FOR EXECUTE
		format(
			'SELECT
				youtuber, rank 
			FROM tb_youtubers
			WHERE started >= $1 AND (category = $2 OR category = $3)
			', v_tabela
		) USING video_count, category_sport, category_music;
		
		LOOP
			FETCH cursor_rank_youtuber INTO tupla;
			EXIT WHEN NOT FOUND;
			RAISE NOTICE '%', tupla;
		END LOOP;
		CLOSE cursor_rank_youtuber;
		
	END;
$$
-- 1.2 Escreva um cursor que exibe todos os nomes dos youtubers em ordem reversa. Para tal
-- - O SELECT deverá ordenar em ordem não reversa
-- - O Cursor deverá ser movido para a última tupla
-- - Os dados deverão ser exibidos de baixo para cima
DO $$
	DECLARE
	cur_reverse REFCURSOR;
	tupla RECORD;
	BEGIN
		OPEN cur_reverse SCROLL FOR
			SELECT youtuber
			FROM tb_youtubers
			ORDER BY youtuber;
		MOVE LAST FROM cur_reverse;
	LOOP
		FETCH BACKWARD FROM cur_reverse INTO tupla;
		EXIT WHEN NOT FOUND;
		RAISE NOTICE '%', tupla.youtuber;
	END LOOP;
	CLOSE cur_reverse;
END;
$$

	