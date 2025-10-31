defmodule Piezas do
  defmodule Pieza do
    defstruct codigo: "", nombre: "", valor: 0, unidad: "", stock: 0
  end

  # Punto A
  def leer_archivo(ruta) do
    case File.read(ruta) do
      {:ok, contenido} ->
        lineas = String.split(String.trim(contenido), "\n", trim: true)
        {:ok, leer_lineas(lineas, [])}

      {:error, razon} ->
        {:error, razon}
    end
  end

  defp leer_lineas([], acumulado), do: Enum.reverse(acumulado)

  defp leer_lineas([linea | resto], acumulado) do
    case String.split(linea, ",") do
      [codigo, nombre, valor_str, unidad, stock_str] ->
        {valor, _} = Integer.parse(valor_str)
        {stock, _} = Integer.parse(stock_str)
        pieza = %Pieza{codigo: codigo, nombre: nombre, valor: valor, unidad: unidad, stock: stock}
        leer_lineas(resto, [pieza | acumulado])

      _ ->
        {:error, "Línea inválida"}
    end
  end

  #Punto B
  def contar_bajo_stock([], _t), do: 0
  def contar_bajo_stock([%Pieza{stock: s} | resto], t) when s < t, do: 1 + contar_bajo_stock(resto, t)
  def contar_bajo_stock([_ | resto], t), do: contar_bajo_stock(resto, t)
end
