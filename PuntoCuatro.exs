def eliminar_duplicados(piezas) do
  eliminar_duplicados_rec(piezas, [])
end

# Caso base
defp eliminar_duplicados_rec([], resultado), do: resultado

# Caso recursivo
defp eliminar_duplicados_rec([pieza | resto], resultado) do
  nuevo_resultado = eliminar_por_codigo(resultado, pieza.codigo)
  eliminar_duplicados_rec(resto, [pieza | nuevo_resultado])
end

defp eliminar_por_codigo([], _codigo), do: []

defp eliminar_por_codigo([%{codigo: c} | resto], codigo) when c == codigo,
  do: eliminar_por_codigo(resto, codigo)

defp eliminar_por_codigo([pieza | resto], codigo),
  do: [pieza | eliminar_por_codigo(resto, codigo)]
