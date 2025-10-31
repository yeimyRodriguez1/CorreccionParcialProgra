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

  # --- Punto A ---
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

  # --- Punto B ---
  def guardar_inventario(nombre_archivo, piezas) do
    lineas =
      for p <- piezas do
        "#{p.codigo},#{p.nombre},#{p.valor},#{p.unidad},#{p.stock}"
      end

    File.write(nombre_archivo, Enum.join(lineas, "\n"))
  end

  #Punto 3
  def analizar_movimientos(movs, fini, ffin) do
    with true <- validar_formato(fini),
         true <- validar_formato(ffin),
         true <- fini <= ffin do
      {:ok, analizar_rango(movs, fini, ffin, MapSet.new(), 0)}
    else
      _ -> {:error, "Fechas inválidas o rango incorrecto"}
    end
  end

  defp analizar_rango([], _fini, _ffin, dias, max_cant),
    do: {MapSet.size(dias), max_cant}

  defp analizar_rango(
         [%Movimiento{fecha: fecha, cantidad: cant} | resto],
         fini,
         ffin,
         dias,
         max_cant
       ) do
    if fecha >= fini and fecha <= ffin do
      nuevos_dias = MapSet.put(dias, fecha)
      nuevo_max = if cant > max_cant, do: cant, else: max_cant
      analizar_rango(resto, fini, ffin, nuevos_dias, nuevo_max)
    else
      analizar_rango(resto, fini, ffin, dias, max_cant)
    end
  end

  defp validar_formato(fecha) do
    Regex.match?(~r/^\d{4}-\d{2}-\d{2}$/, fecha)
  end
end
