defmodule Movimientos do
  defmodule Movimiento do
    defstruct codigo: "", tipo: "", cantidad: 0, fecha: ""
  end

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
      [codigo, tipo, cantidad_str, fecha] ->
        {cantidad, _} = Integer.parse(cantidad_str)
        mov = %Movimiento{codigo: codigo, tipo: tipo, cantidad: cantidad, fecha: fecha}
        leer_lineas(resto, [mov | acumulado])

      _ ->
        {:error, "Línea inválida"}
    end
  end

  #Punto A
  def aplicar_movimientos(piezas, movimientos) do
    for pieza <- piezas do
      stock_final = calcular_stock(pieza.stock, pieza.codigo, movimientos)
      %{pieza | stock: stock_final}
    end
  end

  defp calcular_stock(stock, _codigo, []), do: stock

  defp calcular_stock(stock, codigo, [%Movimiento{codigo: c, tipo: "ENTRADA", cantidad: cant} | resto]) when c == codigo,
    do: calcular_stock(stock + cant, codigo, resto)

  defp calcular_stock(stock, codigo, [%Movimiento{codigo: c, tipo: "SALIDA", cantidad: cant} | resto]) when c == codigo,
    do: calcular_stock(stock - cant, codigo, resto)

  defp calcular_stock(stock, codigo, [_ | resto]),
    do: calcular_stock(stock, codigo, resto)

  #Punto B
  def guardar_inventario(nombre_archivo, piezas) do
    lineas =
      for p <- piezas do
        "#{p.codigo},#{p.nombre},#{p.valor},#{p.unidad},#{p.stock}"
      end

    File.write(nombre_archivo, Enum.join(lineas, "\n"))
  end
end
