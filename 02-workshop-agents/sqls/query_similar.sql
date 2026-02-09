SELECT
  p.persona,
  VECTOR_DISTANCE(
    p.persona_vec,
    VECTOR(:embedding),
    COSINE
  ) AS cosine_distance
FROM personas100 p ORDER BY COSINE_DISTANCE
FETCH FIRST :max_results ROWS ONLY;